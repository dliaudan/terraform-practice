# terraform-practice
Purpose of this project is to create ec2 instance with RHEL 9 distributions, here is created next AWS elements for working this instance correctly:
1. Created VPC, routing table, internet gateway for interconnection to EC2 via SSH
2. Created security group (SG) which allows HTTP, HTTPS, SSH services
3. Additionally added bash script for installing docker and docker compose on instance automatically

Planned tasks:
1. Add NACL
2. Defining subnets for availability zones
3. Defining ec2 instances for AZ
4. Creating multiple instances
