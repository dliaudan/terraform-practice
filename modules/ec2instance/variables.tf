variable "instance_name" {
  description = "The instance name"
  type        = string
  default     = "Non-defined"
}

variable "ami_type" {
  description = "The ami type of EC2 instance. By default, it will be Amazon Linux"
  type        = string
  default     = "ami-01a7573bb17a45f12"
}

variable "instance_subnet" {
  description = "value"
  type = string
  default = ""
}

variable "security_group_id" {
  description = "Security group ID. By default it is none"
  type        = list
  default     = []
}

variable "instance_type" {
  description = "Instance type. By default, it will be t3.micro"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_ssh" {
  description = "Specify key pair for SSH authentication to EC2 instance. By default, it will be keypairssh"
  type        = string
  default     = "keypairssh"
}

variable "ebs_size" {
  description = "EBS volume size. By default, it will be 8 GiB"
  type        = number
  default     = 8
}

variable "number_of_instances" {
 description = "Define how many instances need to create, by default, it is 1"
 type        = number
 default     = 1
}

variable "script_file" {
 description = "Define user data, by default, it is empty"
 type        = string
 default     = ""
}

variable "instance_profile" {
  description = "Define instance profile"
  type        = string
  default     = ""
}

variable "azs" {
  description = "Availability zone"
  type        = string
  default     = "eu-north-1a"
}

variable "volume_type" {
  description = "Volume type of EBS"
  type        = string
  default     = "gp2"
}

variable "where_to_attach_disk" {
  description = "Define path of attaching disk"
  type        = string
  default     = "/dev/xvdh"
}

variable "need_public_ip" {
  description = "Define need for your instance public ip. By default, yes"
  type        = bool
  default     = true
}