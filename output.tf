output "ami_instance_public" {
  description = "AMI instance public"
  value       = aws_instance.ec2-fiap-test-public
}

output "fingerprint" {
  value = data.aws_key_pair.lab-fiap-pair.fingerprint
}

output "name" {
  value = data.aws_key_pair.lab-fiap-pair.key_name
}

output "id" {
  value = data.aws_key_pair.lab-fiap-pair.id
}

output "ecr-repository" {
  value = aws_ecr_repository.ecr-repo.repository_url
}