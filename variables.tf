#this file contains variables for better code flexibility
#currently here was created variables for access keys which defines user of AWS, thus everyone can use this code

variable "access_key" {
	description = "Access Key for AWS"
	type = string
	default = "XXX" #insert here your access key instead of XXX
}

variable "secret_access_key" {
	description = "Secret access key for AWS"
	type = string
	default = "XXX" #insert here your secret access key instead of XXX
}

