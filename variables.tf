#this file for future variables during terraform restructuring

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