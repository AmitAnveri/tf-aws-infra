resource "aws_lambda_function" "email_verification_lambda" {
  function_name = "${var.vpc_name}_email_verification_lambda"
  runtime       = "java17"
  handler       = "com.csye6225.lambda.EmailVerificationLambda::handleRequest"
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = 900

  environment {
    variables = {
      MAILGUN_API_KEY     = var.mailgun_api_key
      MAILGUN_DOMAIN      = var.mailgun_domain
      DB_SECRET_NAME      = aws_secretsmanager_secret.db_credentials.name
      VERIFICATION_EXPIRY = var.verification_expiry
    }
  }

  filename         = var.lambda_jar_path
  source_code_hash = filebase64sha256(var.lambda_jar_path)

  vpc_config {
    subnet_ids         = aws_subnet.private_subnets[*].id
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  depends_on = [aws_sns_topic.email_verification_topic]
}