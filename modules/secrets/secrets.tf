resource "aws_secretsmanager_secret" "create_secret" {
  name                    = var.secretsmanager_name
  description             = var.secretsmanager_description
  recovery_window_in_days = var.secretsmanager_recovery_window_in_days
}

resource "aws_secretsmanager_secret_version" "create_secret_version" {
  secret_id = aws_secretsmanager_secret.create_secret.id

  secret_string = jsonencode({
    api_key = var.secretsmanager_string_api_key
  })
}

