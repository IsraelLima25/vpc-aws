resource "aws_internet_gateway" "internet-g" {
  vpc_id = aws_vpc.vpc-dev.id

  tags = {
    Name     = "main",
    Ambiente = "DEV"
  }
}