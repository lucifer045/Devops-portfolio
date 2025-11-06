resource "aws_vpc" "this" {
    cidr_block = var.cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "${var.env}-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.this.id
    tags = {
        Name = "${var.env}-igw"
    }
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.this.id
    cidr_block = var.public_subnet_cidr
    availability_zone = var.az 
    map_public_ip_on_launch = true
    tags = {
      Name = "${var.env}-public-subnet"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id
    tags = {
        Name = "${var.env}-public-route"
    }
}

resource "aws_route_table_association" "public_access" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "default_route" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}