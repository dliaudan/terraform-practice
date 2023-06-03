variable "vpc_id" {
    description         = "vpc_id for which SG will be attached"
    type                = string 
}

variable "name_of_sg" {
    description         = "Name of security group"
    type                = string
    default             = "Default security group"
}