# here you can enter non default variables

#============================
# Variables for VPC and EBS #
#============================

cidr = "10.0.0.0/16"

cidr_block_first = "10.0.11.0/24"

cidr_block_second = "10.0.12.0/24"

azs_first = "eu-north-1a"

azs_second = "eu-north-1b"

ebs_size = 10

launch_template_name = "asg_launch_template"

image_id = "ami-02b836c630f9af552"

instance_size = "t3.micro"

asg_name = "asg_dliaudan"

maximum_instances = 3

minimum_instances = 1

desired_instances = 2
