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

variable "cidr_block_first" {
  description = "The CIDR block for the subnet. By default, you need to specify it in your variables.tfvars"
  type        = string
  default     = ""
}

variable "cidr_block_second" {
  description = "The CIDR block for the subnet. By default, you need to specify it in your variables.tfvars"
  type        = string
  default     = ""
}

variable "azs_first" {
  description = "The Availability zone for VPC. By default, you need to specify it in your variables.tfvars"
  type        = string
  default     = ""
}

variable "azs_second" {
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

#============================
# Variables for ALB and ASG #
#============================

variable "launch_template_name" {
  description = "Define name of launch template. By default, you need to specify it in your variables.tfvars"
  type        = string
  default     = "Default_template"
}

variable "image_id" {
  description = "Define image id. By default, you need to specify it in your variables.tfvars"
  type        = string
  default     = ""
}

variable "instance_size" {
  description = "Define instance type. By default, you need to specify it in your variables.tfvars"
  type        = string
  default     = ""
}

variable "asg_name" {
  description = "Define ASG name. By default, you need to specify it in your variables.tfvars"
  type        = string
  default     = "Default ASG name"
}

variable "maximum_instances" {
  description = "Define maximum instances on ASG. By default, you need to specify it in your variables.tfvars"
  type        = number
  default     = 0
}

variable "minimum_instances" {
  description = "Define minimum instances on ASG. By default, you need to specify it in your variables.tfvars"
  type        = number
  default     = 0
}

variable "desired_instances" {
  description = "Define desired instances on ASG. By default, you need to specify it in your variables.tfvars"
  type        = number
  default     = 0
}