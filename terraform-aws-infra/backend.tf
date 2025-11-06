/***terraform {
  backend "s3" {
    bucket = "aws-tf-state-us-west-1"
    key = "dev/terraform.tfstate"
    region = "us-west-1"
    dynamodb_table = "terraform-state-lock"
    encrypt = true
  }
}***/