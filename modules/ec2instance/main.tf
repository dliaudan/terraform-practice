#main body with creating ec2 instance
resource "aws_instance" "this" {
  ami                         = var.ami_type
  instance_type               = var.instance_type
  subnet_id                   = var.instance_subnet
  vpc_security_group_ids      = var.security_group_id
  key_name                    = var.key_pair_ssh 
  user_data                   = file("${var.script_file}")
  count                       = var.number_of_instances
  iam_instance_profile        = var.instance_profile 
  associate_public_ip_address = var.need_public_ip

  tags = {
    Name = "${var.instance_name}-${count.index}"
  }
}

#creating EBS resources and attach it to the EC2 instance
resource "aws_ebs_volume" "this" {
  availability_zone     = var.azs
  size                  = var.ebs_size 
  type                  = var.volume_type
  count                 = var.number_of_instances
}

#creating attachment for connecting EC2 instance with EBS volume
resource "aws_volume_attachment" "this" {
  count                 = var.number_of_instances
  device_name           = var.where_to_attach_disk
  volume_id             = "${aws_ebs_volume.this[count.index].id}"
  instance_id           = aws_instance.this[count.index].id
}