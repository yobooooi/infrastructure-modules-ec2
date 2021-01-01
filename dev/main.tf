resource "aws_launch_configuration" "wordpress_ec2" {
    image_id             = var.wordpress_ec2_ami
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
    target_group_arns    = [aws_lb_target_group.wordpress_targetgroup.arn]

    # tags used to launch the ec2 instance with
    
    tags = concat(
      [
        {
          "key"                 = "Name"
          "value"               = "asg-ec2-wordpress-${var.application}"
          "propagate_at_launch" = true
        }
      ],
      var.addiontal_asg_tags,
    )
}

# using a template resource to create the userdata 
data "template_file" "wordpress_ec2_launch_configuration_userdata" {
    template = file("${path.module}/scripts/userdata.sh")
    vars = {
        efs_id     = "placeholder"
    }
}

# autoscaling group security group
resource "aws_security_group" "wordpress_ec2_security_group" {
    name = "sgrp-${var.application}"
    vpc_id = var.vpc_id
    tags = local.common_tags

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
    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}