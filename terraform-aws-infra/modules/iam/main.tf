# IAM role with S3 read permisiion and basis SSM

resource "aws_iam_role" "ec2_role" {
    name = var.role_name
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })
    tags = {
        Name = var.role_name
    }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "s3_readonly" {
  role = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_profile"{
  name = "${var.role_name}-profile"
  role = aws_iam_role.ec2_role.name
}