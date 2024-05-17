data "aws_secretsmanager_secret_version" "postgresql_credentials" {
  secret_id = aws_secretsmanager_secret.postgresql_credentials.id
  depends_on = [aws_secretsmanager_secret.postgresql_credentials]
}

resource "aws_secretsmanager_secret" "postgresql_credentials" {
  name = "fgcasesecret-postgresql-credentials"
}

resource "aws_secretsmanager_secret_version" "postgresql_credentials_version" {
  secret_id     = aws_secretsmanager_secret.postgresql_credentials.id
  secret_string = jsonencode({
    username = "admfatih",
    password = random_password.postgresql_credentials.result  
  })
  depends_on = [aws_secretsmanager_secret.postgresql_credentials]
}


resource "random_password" "postgresql_credentials" {
  length      = 20
  special     = false
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
}