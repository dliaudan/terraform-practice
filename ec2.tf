#description: this terraform script creates 1 ec2 instance which has:
#1. RHEL OS
#2. security group which allows ingress ports 22,80,443
#3. has his own ssh keypair
#4. shows public ip 
#5. can automatically install docker (in process)



#configure region
provider "aws" {
  region     = "eu-north-1"
  profile    = "admin"
}


#create vpc for ec2
resource "aws_vpc" "main_for_terraform" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terraform"
  }
}

#create subnet for vpc
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main_for_terraform.id
  cidr_block = "10.0.11.0/24"

  tags = {
    Name = "Main_subnet"
  }
}

#create gateway for vpc
resource "aws_internet_gateway" "GW-for-TF" {
  vpc_id = aws_vpc.main_for_terraform.id

  tags = {
    Name = "main"
  }
}

#create routing table
resource "aws_route_table" "route-table-aws" {
  vpc_id = aws_vpc.main_for_terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.GW-for-TF.id
  }
#IMPORTANT: local routes created by default. No need to configure here.
}

#creating route table association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.route-table-aws.id
}

#creating security group
resource "aws_security_group" "terraform_default_SG" {
  name        = "terraform_security_group"
  description = "Allow 22, 80, 443 ports"
  vpc_id      = aws_vpc.main_for_terraform.id
#each ingress means one ingress rule
  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["188.163.81.21/32"] #my ip address
  }

  ingress {
    description      = "HTTP from VPC"
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

resource "aws_instance" "web-server-test" {
  ami                    = "ami-0a6351192ce04d50c"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.terraform_default_SG.id]
  key_name               = "keypairssh" 
  #here need to add user data bash script to install docker

  tags = {
    Name = "training_instance"
  }
}

#create elastic IP for EC2 instance
resource "aws_eip" "elasticip" {
  instance = aws_instance.web-server-test.id
}

output "EIP" {
    value = aws_eip.elasticip.public_ip
}