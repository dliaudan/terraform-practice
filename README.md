## terraform-practice

# Important notes

- To use this code, you need to enter your AWS access key credentials into variables file (see comments in this file where to enter it)

# Purpose of this project

Create ec2 instance with RHEL 9 distributions, here is created next AWS elements for working this instance correctly:
1. Created VPC, routing table, internet gateway for interconnection to EC2 via SSH
2. Created security group (SG) which allows HTTP, HTTPS, SSH services
3. Additionally added bash script for installing docker and docker compose on instance automatically
4. Also added possibility to use code for different users through access keys variables

# Planned tasks:
1. Add NACL
2. Defining subnets for availability zones 
3. Defining ec2 instances for AZ
4. Creating multiple instances
