resource "aws_security_group" "this" {
  name        = var.name_of_sg
  description = "Allow 22, 80, 443 ports"
  vpc_id      = var.vpc_id
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
    Name = "Provided by terraform"
  }
}