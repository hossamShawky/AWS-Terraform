#Subnets

resource "aws_subnet" "subnets" {
  count                   = length(var.cidrs)
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = var.type == "public" ? true : false
  tags = {
    "Name" = "${var.project}-Subnet_${var.type}-${var.availability_zones[count.index]}"
  }

}
resource "aws_route_table" "Route-Table" {
  vpc_id = var.vpc_id
  route {
    gateway_id = var.type == "public" ? var.igw : var.nat
    cidr_block = var.destination
  }
  tags = {
    "Name" = "${var.project}-${var.type}-Route-Table"
  }
}
resource "aws_route_table_association" "Route-Table-Ass" {
  count          = length(var.cidrs)
  route_table_id = aws_route_table.Route-Table.id
  subnet_id      = aws_subnet.subnets[count.index].id
}

