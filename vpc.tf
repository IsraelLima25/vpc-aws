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
  availability_zone = "us-east-1a"

  tags = {
    Name     = "dev-public-sub",
    Ambiente = "DEV"
  }
}

resource "aws_subnet" "private-a" {
  vpc_id     = aws_vpc.vpc-dev.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name     = "dev-private-sub-a",
    Ambiente = "DEV"
  }
}

resource "aws_subnet" "private-b" {
  vpc_id     = aws_vpc.vpc-dev.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name     = "dev-private-sub-b",
    Ambiente = "DEV"
  }
}

resource "aws_db_subnet_group" "mysql" {
  name       = "mysql-subnet-group"
  subnet_ids = [aws_subnet.private-a.id, aws_subnet.private-b.id]

  tags = {
    Name = "MySQL subnet group"
  }
}