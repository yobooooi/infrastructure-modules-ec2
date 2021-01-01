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

variable "wordpress_ec2_ami" {
    description= "asg ami to be used"
    default = "ami-01720b5f421cf0179"
}

variable "addiontal_asg_tags" {
  default = [
    {
      key                 = "Application"
      value               = "Terratest-WordPress"
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = "Adan"
      propagate_at_launch = true
    },
  ]
}