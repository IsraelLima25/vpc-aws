resource "aws_eks_cluster" "dev" {
  name     = "dev-eks"
  role_arn = data.aws_iam_role.labrole.arn

  vpc_config {
    subnet_ids = [aws_subnet.private-a.id, aws_subnet.private-b.id]
  }
  version = "1.29"
}

resource "aws_eks_node_group" "dev_nodes" {
  cluster_name    = aws_eks_cluster.dev.name
  node_group_name = "dev-nodes"
  node_role_arn   = data.aws_iam_role.labrole.arn
  subnet_ids      = [aws_subnet.private-a.id, aws_subnet.private-b.id]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  remote_access {
    ec2_ssh_key               = data.aws_key_pair.lab-fiap-pair.key_name
    source_security_group_ids = [aws_security_group.allow_http.id]
  }
}