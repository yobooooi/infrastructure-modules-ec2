variable "application" {
    description = ""
    default = "infrastructure-modules-ec2"
}

variable "ec2_instance_type" {
    description = "instance type of the EC2 instance"
    default     = "t2.micro"
}

variable "ec2_root_block_size" {
    description = "root volumes size of the EC2 instances"
    default     = "25"
}

variable "ec2_subnets" {
    description = "subnet in which to deploy launch EC2 instances"
}

variable "vpc_id"{
    description= ""
}

variable "ami_owners" {
    description= ""
    default = ["296274010522"]
}

variable "ami_name_filter" {
    default = ["dev-wordpress-latest-AMZN-baseimage-*"]
}