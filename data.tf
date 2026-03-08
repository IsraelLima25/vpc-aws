data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_key_pair" "lab-fiap-pair" {
  key_name = "vockey"
}

data "aws_iam_role" "labrole" {
  name = "LabRole"
}


data "aws_eks_node_group" "dev_nodes" {
  cluster_name    = aws_eks_cluster.dev.name
  node_group_name = aws_eks_node_group.dev_nodes.node_group_name
}

data "aws_autoscaling_group" "eks_asg" {
  name = data.aws_eks_node_group.dev_nodes.resources[0].autoscaling_groups[0].name
}

data "aws_eks_cluster" "dev" {
  name = aws_eks_cluster.dev.name
}

data "aws_eks_cluster_auth" "dev" {
  name = aws_eks_cluster.dev.name
}

data "tls_certificate" "eks_issuer" {
  url = data.aws_eks_cluster.dev.identity[0].oidc[0].issuer
}