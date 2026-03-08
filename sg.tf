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
    cidr_blocks = [aws_vpc.vpc-dev.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_vpc_security_group_ingress_rule" "kubelet" {
  security_group_id            = aws_security_group.allow_node_port.id
  referenced_security_group_id = aws_security_group.allow_node_port.id
  from_port                    = 10250
  to_port                      = 10250
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "node_internal" {
  security_group_id            = aws_security_group.allow_node_port.id
  referenced_security_group_id = aws_security_group.allow_node_port.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "node_vpc_internal" {
  security_group_id = aws_security_group.allow_node_port.id
  cidr_ipv4         = aws_vpc.vpc-dev.cidr_block
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "metric" {
  security_group_id            = aws_security_group.allow_node_port.id
  referenced_security_group_id = aws_security_group.allow_node_port.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
}

resource "aws_security_group" "eks_cluster" {
  name   = "eks-cluster-sg"
  vpc_id = aws_vpc.vpc-dev.id
}

resource "aws_vpc_security_group_ingress_rule" "eks_api_from_nodes" {
  security_group_id            = aws_security_group.eks_cluster.id
  referenced_security_group_id = aws_security_group.allow_node_port.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "dns_udp" {
  security_group_id            = aws_security_group.allow_node_port.id
  referenced_security_group_id = aws_security_group.allow_node_port.id
  from_port                    = 53
  to_port                      = 53
  ip_protocol                  = "udp"
}

resource "aws_vpc_security_group_ingress_rule" "dns_tcp" {
  security_group_id            = aws_security_group.allow_node_port.id
  referenced_security_group_id = aws_security_group.allow_node_port.id
  from_port                    = 53
  to_port                      = 53
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "node_to_cluster_api" {
  security_group_id            = aws_security_group.allow_node_port.id
  referenced_security_group_id = aws_security_group.eks_cluster.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
}