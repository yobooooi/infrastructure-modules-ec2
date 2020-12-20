output "wordpress_launch_configuration_id" {
  value = aws_launch_configuration.wordpress_ec2.id
}

output "wordpress_instance_profile_id" {
  value = aws_iam_instance_profile.wordpress_ec2_instance_profile.id
}

output "wordpress_security_group_id" {
  value = aws_security_group.wordpress_ec2_security_group.id
}