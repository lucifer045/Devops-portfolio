variable "cidr_block" {
}
variable "env" {
}
variable "public_subnet_cidr" {
    type = list(string)
}
variable "az" {
    type = list(string)
}
variable "private_subnet_cidr" {
    type = list(string)
}
