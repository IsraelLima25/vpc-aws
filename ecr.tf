resource "aws_ecr_repository" "ecr-repo" {
  name                 = "oficina-api-dev"
  image_tag_mutability = "MUTABLE"
}