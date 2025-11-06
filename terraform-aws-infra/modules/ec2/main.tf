data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]

    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_security_group" "sg" {
  name = "${var.env}-sg"
  description = "Allow HTTP and SSH"
  vpc_id = var.vpc_id

    ingress  {
      description = "HTTP"
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress  {
      description = "SSH"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [var.ssh_cidr]
    }

    egress  {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-sg"
  }
}

resource "aws_instance" "app" {
  ami = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id 
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = var.key_name
  iam_instance_profile = var.iam_instance_profile

  user_data = file("./user-data.sh")

  tags = {
    Name = "${var.env}-app"
  }
}

resource "aws_eip" "app_eip" {
  instance = aws_instance.app.id
  domain = "vpc"
}
