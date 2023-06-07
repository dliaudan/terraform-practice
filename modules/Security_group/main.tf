resource "aws_security_group" "this" {
  name        = var.name_of_sg
  description = var.description
  vpc_id      = var.vpc_id
#each ingress means one ingress rule, creating ingress rules predicted by list that you write down in your module
  dynamic "ingress" {
    for_each = var.inbound_ports
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
    }
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name_of_sg
  }
}