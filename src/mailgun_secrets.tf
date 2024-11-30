resource "aws_secretsmanager_secret" "mailgun_api_key" {
  name        = "${var.vpc_name}_mailgun_api_key-1"
  description = "Mailgun API key for sending email verification emails"
  kms_key_id  = aws_kms_key.secrets_encryption_key.arn
  recovery_window_in_days = 0

  tags = {
    Name = "${var.vpc_name}_mailgun_api_key"
  }
}

resource "aws_secretsmanager_secret_version" "mailgun_api_key_version" {
  secret_id = aws_secretsmanager_secret.mailgun_api_key.id
  secret_string = jsonencode({
    MAILGUN_API_KEY = var.mailgun_api_key
    MAILGUN_DOMAIN  = var.mailgun_domain
  })
}
