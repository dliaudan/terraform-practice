#description: this terraform script creates 1 ec2 instance which has:
#1. RHEL OS
#2. security group which allows ingress ports 22,80,443
#3. has his own ssh keypair
#4. shows public ip 
#5. can automatically install docker 



#configure region, also configure access keys and configs from respective for flexible code usage
provider "aws" {
  profile = "default"
}

#this data gives awss user identity. From this data you can give an output of account ID, ARN of user ID
data "aws_caller_identity" "this" {

}

data "aws_secretsmanager_secret" "this" {
  name = aws_secretsmanager_secret.this.id
}

#create vpc for ec2
resource "aws_vpc" "this" {
  cidr_block       = var.cidr
  instance_tenancy = "default"

  tags = {
    Name = "terraform"
  }
}

#create subnet for vpc
resource "aws_subnet" "this" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.cidr_block
  availability_zone = var.azs

  tags = {
    Name = "terraform"
  }
}

#create gateway for vpc
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "terraform"
  }
}

#create routing table
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.this.id
  }
#IMPORTANT: local routes created by default. No need to configure here.
}

#creating route table association
resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}

#creating security group
module "Security_group" {
  source      = ".//modules/Security_group"
  vpc_id      = "${aws_vpc.this.id}"
  name_of_sg  = "Basic security group"
}

#creating EC2 instance 
module "module_server_test" {
  source                    = ".//modules/ec2instance"
  instance_subnet           = "${aws_subnet.this.id}"
  security_group_id         = "${[module.Security_group.Security_group_id]}"
  number_of_instances       = 2
  instance_name             = "Webserver"
  script_file               = "script-docker-install-rhel.sh"
}

#creating EBS resources and attach it to the EC2 instance
resource "aws_ebs_volume" "this" {
  availability_zone     = var.azs
  size                  = var.ebs_size 
  type                  = "gp2" #general purpose
}

#creating attachment for connecting EC2 instance with EBS volume
resource "aws_volume_attachment" "this" {
  device_name           = "/dev/xvdh"
  volume_id             = "${aws_ebs_volume.this.id}"
  instance_id           = module.module_server_test.ec2_ids[0] 
}

#creating secret random password
resource "random_password" "this" {
  length  = 16
  special = true
  numeric = true
  upper   = true
  lower   = true
}

#creating empty secret resource
resource "aws_secretsmanager_secret" "this" {
  name        = "secret_password_test"
  description = "Secret password for future purposes"
  recovery_window_in_days = 0
  tags = {
    Name      = "secret_pass"
  }
}

#binding random password with secret
resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id 
    secret_string = <<EOF
  {
    "username":"adminDB",
    "password":"${random_password.this.result}"
  }
  EOF
}

