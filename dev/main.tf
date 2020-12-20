resource "aws_launch_configuration" "wordpress_ec2" {
    image_id             = data.aws_ami.wordpress_ami.id
    instance_type        = var.ec2_instance_type
    iam_instance_profile = aws_iam_instance_profile.wordpress_ec2_instance_profile.id

    root_block_device {
        volume_type           = "standard"
        volume_size           = var.ec2_root_block_size
        delete_on_termination = true
    }

    lifecycle {
        create_before_destroy = true
    }

    security_groups             = [aws_security_group.wordpress_ec2_security_group.id]
    associate_public_ip_address = true

    user_data = data.template_file.wordpress_ec2_launch_configuration_userdata.rendered
}

# creating autoscaling group and associating it to the target group cofigured for the
# application load balancer
resource "aws_autoscaling_group" "wordpress_ec2_autoscaling_group" {
    name                 = "asg-wordpress-${var.application}"
    max_size             = "2"
    min_size             = "1"
    desired_capacity     = "1"
    vpc_zone_identifier  = var.ec2_subnets
    launch_configuration = aws_launch_configuration.wordpress_ec2.name
    health_check_type    = "EC2"

    # tags used to launch the ec2 instance with
    tag {
        key                 = "Name"
        value               = "asg-ec2-wordpress-${var.application}"
        propagate_at_launch = true
    }

}

# using a template resource to create the userdata 
data "template_file" "wordpress_ec2_launch_configuration_userdata" {
    template = file("${path.module}/scripts/userdata.sh")
    vars = {
        efs_id     = "placeholder"
    }
}

# sourcing the ami for the wordpress ec2 instances. 
data "aws_ami" "wordpress_ami" {
    most_recent = true
    owners = var.ami_owners
    
    filter {
        name   = "tag:Name"
        values = var.ami_name_filter
    }
}

# autoscaling group security group
resource "aws_security_group" "wordpress_ec2_security_group" {
    name = "sgrp-${var.application}"
    vpc_id = var.vpc_id

    ingress {
        from_port = 8
        to_port = 0
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}