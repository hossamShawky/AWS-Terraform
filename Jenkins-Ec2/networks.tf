resource "aws_vpc" "jenkins_vpc" {
  cidr_block = var.cidr_block
  tags = {
    "Name" = "${var.project}-vpc"
  }
  enable_dns_hostnames = true

}

resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.jenkins_vpc.id
  tags = {
    "Name" = "${var.project}-igw"
  }
}

resource "aws_subnet" "jenkins_subnet" {
  vpc_id     = aws_vpc.jenkins_vpc.id
  cidr_block = var.subnet_cidr
  tags = {
    "Name" = "${var.project}-public-subnet"
  }
  map_public_ip_on_launch = true
}

resource "aws_route_table" "jenkins_route_table" {
  vpc_id = aws_vpc.jenkins_vpc.id
  route {
    gateway_id = aws_internet_gateway.jenkins_igw.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    "Name" = "${var.project}-public-route-table"
  }
}

resource "aws_route_table_association" "jenkins_route_table_association" {
  route_table_id = aws_route_table.jenkins_route_table.id
  subnet_id      = aws_subnet.jenkins_subnet.id
}