output "sg_id" {
    description = "Identifier of security group for attaching ot EC2 instances"
    value = aws_security_group.this.id
}

output "name" {
    description = "Name of security group for attaching ot EC2 instances"
    value = aws_security_group.this.name
}