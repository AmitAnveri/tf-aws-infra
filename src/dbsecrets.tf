# Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${var.vpc_name}_db_credentials-2"
  description = "Database credentials for RDS access"

  tags = {
    Name = "${var.vpc_name}_db_credentials"
  }
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    DB_HOST     = aws_db_instance.rds_instance.address
    DB_PORT     = "5432"
    DB_NAME     = var.db_name
    DB_USERNAME = var.db_username
    DB_PASSWORD = var.db_password
  })
}