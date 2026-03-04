# Lê a senha da variável de ambiente
variable "db_password" {}

# Cria o segredo no Secrets Manager
resource "aws_secretsmanager_secret" "db_secret" {
  name = "meu-app/database-password/v13"
}

resource "aws_secretsmanager_secret_version" "db_secret" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({ password = var.db_password })
}