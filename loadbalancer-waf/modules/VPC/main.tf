resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags       = { "Name" : "${var.project}-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = { "Name" : "${var.project}-igw" }
}