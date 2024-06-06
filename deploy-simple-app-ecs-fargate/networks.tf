resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags = {
    "Name" = "${var.project}-vpc"
  }
}

resource "aws_subnet" "subnet" {

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    "Name" = "${var.project}-subnet"
  }
}
resource "aws_subnet" "subnet2" {

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    "Name" = "${var.project}-subnet"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.project}-igw"
  }
}



resource "aws_route_table" "aws_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    "Name" = "${var.project}-routetable"
  }
}

resource "aws_route_table_association" "aws_route_table_association" {
  route_table_id = aws_route_table.aws_route_table.id
  subnet_id      = aws_subnet.subnet.id
}

resource "aws_route_table_association" "aws_route_table_association2" {
  route_table_id = aws_route_table.aws_route_table.id
  subnet_id      = aws_subnet.subnet2.id
}
