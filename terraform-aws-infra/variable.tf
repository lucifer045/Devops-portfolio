variable "region" {
  type    = string
  default = "us-west-1"
}
variable "env" {
  type    = string
  default = "dev"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}
variable "ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
variable "key_name" {
  type    = string
  default = ""
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "ami_id" {
  type        = string
  default     = ""
  description = "AMI ID to use; if empty, the latest Amazon Linux 2 will be used via data source"
}