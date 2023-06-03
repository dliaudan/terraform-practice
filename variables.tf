#this file for future variables during terraform restructuring

#note: all default variables you can specify on your own purposes. To edit variables see variables.tfvars file

#====================
# Variables for VPC #
#====================
variable "cidr" {
  description = "The CIDR block for the VPC. By default, you need to specify it in your variables.tfvars"
  type        = string
  default     = ""
}

variable "cidr_block" {
  description = "The CIDR block for the subnet. By default, you need to specify it in your variables.tfvars"
  type        = string
  default     = ""
}

variable "azs" {
  description = "The Availability zone for VPC. By default, you need to specify it in your variables.tfvars"
  type        = string
  default     = ""
}

#============================
# Variables for EC2 and EBS #
#============================

variable "ebs_size" {
  description = "EBS volume size. By default, you need to specify it in your variables.tfvars"
  type        = number
  default     = 0
}