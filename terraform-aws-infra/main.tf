locals {
  name_prefix = "${var.env}-demo"
}

# vpc module
module "vpc" {
  source             = "./modules/vpc"
  env                = var.env
  cidr_block         = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  az                 = "us-west-1a"
}

module "iam" {
  source    = "./modules/iam"
  env       = var.env
  role_name = "${local.name_prefix}-ec2-role"
}

module "ec2" {
  source               = "./modules/ec2"
  vpc_id               = module.vpc.vpc_id
  env                  = var.env
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = module.vpc.public_subnet_id
  key_name             = var.key_name
  ssh_cidr             = var.ssh_cidr
  iam_instance_profile = module.iam.aws_iam_instance_profile
}