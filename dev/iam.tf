resource "aws_iam_instance_profile" "wordpress_ec2_instance_profile" {
    name = "test_profile"
    role = aws_iam_role.wordpress_ec2_role.name
}

resource "aws_iam_role" "wordpress_ec2_role" {
  name = "wordpress_ec2_role-${var.application}"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
              "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attachment_ssm_policy" {
    role       = aws_iam_role.wordpress_ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}