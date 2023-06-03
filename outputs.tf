output "account_id" {
  description           = "Gives output of current account ID"
  value                 = data.aws_caller_identity.this.user_id
}

output "secret_name" {
  description           = "Name of the secret"
  value                 = data.aws_secretsmanager_secret.this.name
}


#this outputs are from the module, and they reference from the module outputs
output "instance_name" {
  description           = "Name of the instances"
  value                 = module.module_server_test.ec2_names
}

output "instance_public_ips" {
  description           = "Public ip of the instances"
  value                 = module.module_server_test.public_ip
}