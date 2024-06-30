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
