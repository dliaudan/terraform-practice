output "public_ip" {
    description         = "Gives output of public IP for EC2 instance"
    value               = aws_instance.web_server_test.public_ip
}

output "ec2_instance_name" {
    description         = "Gives output of ec2 name"
    value               = aws_instance.web_server_test.tags.Name
}