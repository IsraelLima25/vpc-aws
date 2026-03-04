resource "aws_eks_cluster" "dev" {
  name     = "dev-eks"
  role_arn = data.aws_iam_role.labrole.arn

  vpc_config {
    subnet_ids = [aws_subnet.private-a.id, aws_subnet.private-b.id]
  }
  version = "1.30"
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

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  instance_types = [var.ec2Instance]
}

resource "aws_launch_template" "eks_nodes" {
  name_prefix = "eks-nodes-"
  image_id    = null

  key_name = data.aws_key_pair.lab-fiap-pair.key_name

  vpc_security_group_ids = [
    aws_security_group.allow_node_port.id,
    aws_security_group.allow_http.id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "eks-node"
    }
  }

}