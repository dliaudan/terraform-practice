#main body with creating ec2 instance
resource "aws_instance" "this" {
  ami                         = var.ami_type
  instance_type               = var.instance_type
  subnet_id                   = var.instance_subnet
  vpc_security_group_ids      = var.security_group_id
  key_name                    = var.key_pair_ssh 
  user_data                   = file("${var.script_file}")
  count                       = var.number_of_instances
  associate_public_ip_address = true

  tags = {
    Name = "${var.instance_name}-${count.index}"
  }
}