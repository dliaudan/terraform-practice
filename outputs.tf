output "public_ip" {
    description         = "Gives output of public IP for EC2 instance"
    value               = aws_instance.web_server_test.public_ip
}

output "ec2_instance_name" {
    description         = "Gives output of ec2 name"
    value               = aws_instance.web_server_test.tags.Name
}

output "account_id" {
  description           = "Gives output of current account ID"
  value                 = data.aws_caller_identity.this.user_id
}

output "secret_name" {
  description           = "Name of the secret"
  value                 = data.aws_secretsmanager_secret.this.name
}