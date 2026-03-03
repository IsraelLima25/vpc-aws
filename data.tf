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

data "aws_autoscaling_group" "eks_asg" {
  name = aws_eks_node_group.dev_nodes.resources[0].autoscaling_groups[0].name
}