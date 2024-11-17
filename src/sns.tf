resource "aws_sns_topic" "email_verification_topic" {
  name = "${var.vpc_name}_email_verification"
}

resource "aws_sns_topic_subscription" "lambda_sns_subscription" {
  topic_arn = aws_sns_topic.email_verification_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.email_verification_lambda.arn

  # Grant SNS permission to invoke the Lambda function
  depends_on = [aws_lambda_function.email_verification_lambda]
}

# Grant permission to the SNS topic to invoke the Lambda function
resource "aws_lambda_permission" "allow_sns_invoke_lambda" {
  statement_id  = "AllowSNSInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email_verification_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.email_verification_topic.arn
}