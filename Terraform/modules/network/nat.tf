resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-nat-eip"
    }
  )
}


resource "aws_nat_gateway" "shopsphere" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [
    aws_internet_gateway.shopsphere
  ]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-nat"
    }
  )
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.shopsphere.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.shopsphere.id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-private-rt"
    }
  )
}


resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "management" {
  count          = length(aws_subnet.management)
  subnet_id      = aws_subnet.management[count.index].id
  route_table_id = aws_route_table.private.id
}