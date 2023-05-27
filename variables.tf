#this file for future variables during terraform restructuring

#====================
# Variables for VPC #
#====================
variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cidr_block" {
  description = "The CIDR block for the subnet. Default value is a valid CIDR"
  type        = string
  default     = "10.0.11.0/24"
}

variable "azs" {
  description = "The Availability zone for VPC. Currently, here is only 1 AZ"
  type        = string
  default     = "eu-north-1a"
}

#============================
# Variables for EC2 and EBS #
#============================

variable "ami_type" {
  description = "The ami type of EC2 instance. By default, it is an RHEL Linux distribution"
  type        = string
  default     = "ami-0a6351192ce04d50c"
}

variable "instance_type" {
  description = "Instance type, by default, it is a t3.micro"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_ssh" {
  description = "Specify key pair for SSH authentication to EC2 instance"
  type        = string
  default     = "keypairssh"
}

variable "ebs_size" {
  description = "EBS volume size, by default, it is 8 GiB size"
  type        = number
  default     = 8
}