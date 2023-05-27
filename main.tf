#description: this terraform script creates 1 ec2 instance which has:
#1. RHEL OS
#2. security group which allows ingress ports 22,80,443
#3. has his own ssh keypair
#4. shows public ip 
#5. can automatically install docker 



#configure region, also configure access keys for flexible code usage
provider "aws" {
  region     = "eu-north-1"
  access_key = var.access_key
	secret_key = var.secret_access_key
}


#create vpc for ec2
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terraform"
  }
}

#create subnet for vpc
resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "eu-north-1a"

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
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
#IMPORTANT: local routes created by default. No need to configure here.
}

#creating route table association
resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}

#creating security group
resource "aws_security_group" "this" {
  name        = "terraform_security_group"
  description = "Allow 22, 80, 443 ports"
  vpc_id      = aws_vpc.this.id
#each ingress means one ingress rule
  ingress {
    description      = "HTTPS from EC2 instance"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH from EC2 instance"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["188.163.81.21/32"] #my ip address
  }

  ingress {
    description      = "HTTP from EC2 instance"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform"
  }
}

#creating EC2 instance 
resource "aws_instance" "web_server_test" {
  ami                    = "ami-0a6351192ce04d50c"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.this.id
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name               = "keypairssh" 
  user_data              = file("script-docker-install-rhel.sh")
  
  tags = {
    Name = "terraform"
  }
}

#creating EBS resources (more RAM) and attach it to the EC2 instance
resource "aws_ebs_volume" "this" {
  availability_zone     = "eu-north-1a"
  size                  = 8 #8 GiB volume of EBS
  type                  = "gp2" #general purpose

}

#creating attachment for connecting EC2 instance with EBS volume
resource "aws_volume_attachment" "this" {
  device_name           = "/dev/xvdh"
  volume_id             = "${aws_ebs_volume.this.id}"
  instance_id           = "${aws_instance.web_server_test.id}" 
}

#create elastic IP for EC2 instance
resource "aws_eip" "this" {
  instance = aws_instance.web_server_test.id
}

#showing elastic ip for me in cli
output "elastic_ip_output" {
    description = "Gives output of elastic IP for EC2 instance"
    value = aws_eip.this.public_ip
}
