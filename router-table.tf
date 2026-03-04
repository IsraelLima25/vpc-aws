resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc-dev.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Ambiente = "DEV"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc-dev.id


  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-g.id
  }

  tags = {
    Ambiente = "DEV"
  }
}

resource "aws_route_table_association" "private-a-rt-association" {
  subnet_id      = aws_subnet.private-a.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-b-rt-association" {
  subnet_id      = aws_subnet.private-b.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "public-a-rt-association" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-b-rt-association" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.public-rt.id
}