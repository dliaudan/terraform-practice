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
  cidr_block        = var.cidr_block_first
  availability_zone = var.azs_first

  tags = {
    Name = "terraform-AZA"
  }
}
#just for DB requirments (for now)
resource "aws_subnet" "this_second" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.cidr_block_second
  availability_zone = var.azs_second

  tags = {
    Name = "terraform-AZB"
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
module "security_group_ec2" {
  source          = ".//modules/Security_group"
  vpc_id          = "${aws_vpc.this.id}"
  name_of_sg      = "Basic security group"
  description     = "Allows ports 22, 80 and 443" 
  inbound_ports   = [22,80,443]
}

#creating policy for instance profile (access to secret manager)
resource "aws_iam_policy" "this" {
  name               = "EC2_role_for_SM"
  path               = "/"
  description        = "Policy for read/write data on secret manager (SM)" 
  policy             = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "secretsmanager:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:Describe*",
                "cloudwatch:*",
                "logs:*",
                "sns:*",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "oam:ListSinks"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "arn:aws:iam::*:role/aws-service-role/events.amazonaws.com/AWSServiceRoleForCloudWatchEvents*",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "events.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "oam:ListAttachedLinks"
            ],
            "Resource": "arn:aws:oam:*:*:sink/*"
        }
    ]
}

  )
}
#create appropriate role for ec2 instance
resource "aws_iam_role" "this" {
  name = "ec2_instance_sm_role_terraform"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [ #statement where rule is defined for allowing ec2 instance service use this role
        {
            "Effect": "Allow", #in effect specify wether deny or allow action
            "Action": [  #specify action that will be allowed or denied
                "sts:AssumeRole" #action is assuming role
            ],
            "Principal": { #fspecify for whom permission will be granted
                "Service": [ #define which services will be impacted for assuming (also here can be accounts)
                    "ec2.amazonaws.com" #especially assuming this role is allowed for ec2 instances
                ]
            }
        }
    ]
}) #assume role defines for which subjects (accounts or instances) this role can be applied
}

#unite iam role and policy
resource "aws_iam_policy_attachment" "this" {
  name       = "ec2_attachment_SM"
  roles      = [aws_iam_role.this.name]
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_instance_profile" "this" {
  name = "ec2_sm_profile"
  role = aws_iam_role.this.name
}

#creating EC2 instance 
module "module_server_test" {
  source                    = ".//modules/ec2instance"
  ami_type                  = "ami-0989fb15ce71ba39e"
  instance_subnet           = "${aws_subnet.this.id}"
  security_group_id         = "${[module.security_group_ec2.sg_id]}"
  number_of_instances       = 2
  instance_name             = "Webserver"
  instance_profile          = "${aws_iam_instance_profile.this.name}" 
  script_file               = "startup_installation.sh"
  key_pair_ssh              = "keypairssh"
  ebs_size                  = 10

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
  name                    = "secret_password_test"
  description             = "Secret password for future purposes"
  recovery_window_in_days = 0
  tags = {
    Name                  = "secret_pass"
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

module "security_group_for_elb" {
  source          = ".//modules/Security_group"
  vpc_id          = "${aws_vpc.this.id}"
  name_of_sg      = "Basic security group for ELB"
  description     = "Allows ports 80 and 443" 
  inbound_ports   = [80,443]
}

#creating classic load balancer
resource "aws_elb" "this" {
  name                      = "ELB"
  subnets                   = [aws_subnet.this.id]
  source_security_group     = module.security_group_for_elb.sg_id
  
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = [module.module_server_test.ec2_ids[0],module.module_server_test.ec2_ids[1]]
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "Classic load balancer"
  }
}

#creating ALB
resource "aws_lb" "this" {
  name                      = "test-alb"
  internal                  = false
  load_balancer_type        = "application"
  source_security_group     = module.security_group_for_elb.sg_id
  subnets                   = [aws_subnet.this.id,aws_subnet.this_second.id,]

  enable_deletion_protection = true #need to delete LB
  access_logs {
    bucket  = "dliaudanbukcet"
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Name = "For test"
  }
}

resource "aws_lb_target_group" "this" {
  name        = "tf-example-lb-alb-tg"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.this.id
}