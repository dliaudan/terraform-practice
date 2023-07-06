# terraform-practice

## Description

This project is purposed for improving practice skills to deploy AWS infrastructure based on terraform scripting. 

## Contents

### Main functionality

In this project you can see realized the following main resources of AWS infrastructure:

1. **VPC**, which includes subnets, route tables, ACL, and gateway to the internet
2. **EC2 instances**, which have an IAM profile for retrieving secrets from SM, specified count of instances, and other default settings
3. **Balancing**, which consists of a combination of **Application load balancer (ALB)** and **Autoscaling group (ASG)**. In addition, created a __Classic load balancer (ELB)__ for testing purposes.
   * ALB has also __target group__ and __listeners__ to make more precisely balancing policy
   * ASG has its own __autoscaling schedule__ which adds for min, max and desired capacity by 1 instance at the morning and reduces respective count by 1 in the evening

### Features

In this project were provided the following features for AWS infrastructure:

1. Remote backend with manually created S3 bucket for sharing `.tfstate` files for different users.
2. Security groups (SG) module which allows putting only a list of ports which makes code more readable and simpler for further developing
3. EC2 instance module with EBS storage which allows to make more clear settings for EC2 instance
4. Bash scripts for installing a) Docker on RHEL b) AWS CLI with cloudwatch custom metrics (ram usage) and retrieving secrets from the secret manager. This practice is very useful if you need to connect from EC2 instance to RDS with already pulled credentials in EC2
5. Outputs instances public IPs so you can SSH to your server more simpler - without login to aws directly to check EC2 instances' public addresses
6. Provided an example of importing manually created RDS and ECR repository which makes sense when you need to integrate already created infrastructure elements in your code.

## How to use this code

1. Clone repo to your local machine
2. Specify credentials (keys and region) on AWS CLI
3. Define your S3 bucket backend and make `terraform init`
4. Edit all necessary variables in `terraform.tfvars` file or in the main.tf if settings related to EC2 instances or SG
5. Add or edit existing bash script for your EC2 instances or launch template for ASG
6. Make `terraform plan` to ensure that you provide the correct settings of your future infrastructure
7. Make `terraform apply`
