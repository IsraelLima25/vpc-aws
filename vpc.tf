resource "aws_vpc" "vpc-dev" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name     = "vpc-dev",
    Ambiente = "DEV"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc-dev.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name     = "dev-public-sub",
    Ambiente = "DEV"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc-dev.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name     = "dev-private-sub",
    Ambiente = "DEV"
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc-dev.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
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

resource "aws_route_table_association" "private-rt-association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc-dev.id

  tags = {
    Name     = "allow_ssh",
    Ambiente = "DEV"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc-dev.id

  tags = {
    Name     = "allow_ssh",
    Ambiente = "DEV"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
