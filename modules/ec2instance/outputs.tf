#this outputs only for module only
#you will not see them in your cmd
#also this outputs needs to reference to another resources/modules in your main.tf code in project

output "public_ip" {
    description         = "Gives output of public IP for EC2 instance"
    value               = aws_instance.this[*].public_ip
}

output "ec2_names" {
    description         = "Gives a names of instance servers"
    value               = aws_instance.this[*].tags_all.Name
}

output "ec2_ids" {
    description         = "Gives a names of instance servers"
    value               = aws_instance.this[*].id
}

