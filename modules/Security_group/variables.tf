variable "vpc_id" {
    description         = "vpc_id for which SG will be attached"
    type                = string 
}

variable "name_of_sg" {
    description         = "Name of security group"
    type                = string
    default             = "Default security group"
}

variable "description" {
    description         = "Description for security group"
    type                = string
    default             = "Default name of SG"
}

variable "inbound_ports" {
    description         = "List of ports that will be allowed by security group"
    type                = list 
    default             = [22,80,443] 
}