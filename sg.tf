resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc-dev.id

  tags = {
    Name     = "allow_ssh",
    Ambiente = "DEV"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress_http" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
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

resource "aws_vpc_security_group_egress_rule" "allow_all_egress_ssh" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "rds_mysql" {
  name        = "rds-mysql-sg"
  description = "Permite acesso MySQL interno na VPC"
  vpc_id      = aws_vpc.vpc-dev.id

  ingress {
    description = "Permitir MySQL de dentro da VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc-dev.cidr_block] # Exemplo: ["10.0.0.0/16"]
    # Alternativamente, pode usar security_groups para liberar só para SGs específicos
  }
}

resource "aws_security_group" "allow_node_port" {
  name        = "allow_node_port"
  description = "Allow nod port inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc-dev.id

  tags = {
    Name     = "allow_ssh",
    Ambiente = "DEV"
  }
}

resource "aws_vpc_security_group_ingress_rule" "nodeport_from_alb" {
  security_group_id            = aws_security_group.allow_node_port.id
  from_port                    = 30080
  to_port                      = 30080
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.allow_http.id

}

resource "aws_vpc_security_group_egress_rule" "nodeport_egress" {
  security_group_id = aws_security_group.allow_node_port.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}