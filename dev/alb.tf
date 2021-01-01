resource "aws_lb_target_group" "wordpress_targetgroup" {
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id
}

# change to use an existing alb and create a loadbalancer rule
resource "aws_lb" "wordpress_applicationloadbalancer" {
    name                       = "alb-${var.application}"
    internal                   = false
    load_balancer_type         = "application"
    security_groups            = [aws_security_group.wordpress_ec2_security_group.id]
    subnets                    = var.ec2_subnets
    enable_deletion_protection = false

    tags = {
        Environment = "alb-${var.application}"
    }
}

resource "aws_lb_listener" "alb-listener" {
    load_balancer_arn = aws_lb.wordpress_applicationloadbalancer.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.wordpress_targetgroup.arn
    }
}