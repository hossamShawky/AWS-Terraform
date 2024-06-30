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