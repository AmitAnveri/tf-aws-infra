resource "aws_iam_role" "web_app_role" {
  name = "${var.vpc_name}_web_app_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "web_app_instance_profile" {
  name = "${var.vpc_name}_web_app_instance_profile"
  role = aws_iam_role.web_app_role.name
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.vpc_name}_s3_access_policy"
  description = "Policy for EC2 instance to access S3 bucket for app image handling"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource = "${aws_s3_bucket.app_images.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_access_policy" {
  role       = aws_iam_role.web_app_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# IAM policy for CloudWatch Agent
resource "aws_iam_policy" "cloudwatch_agent_policy" {
  name        = "${var.vpc_name}_cloudwatch_agent_policy"
  description = "Policy for CloudWatch Agent to publish metrics and logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cloudwatch:PutMetricData",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:CreateLogGroup"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach CloudWatch Agent policy to the IAM role
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_agent_policy" {
  role       = aws_iam_role.web_app_role.name
  policy_arn = aws_iam_policy.cloudwatch_agent_policy.arn
}

resource "aws_iam_policy" "sns_publish_policy" {
  name        = "${var.vpc_name}_sns_publish_policy"
  description = "Policy to allow webapp to publish messages to SNS topic"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sns:Publish"
        ],
        Resource = aws_sns_topic.email_verification_topic.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_sns_publish_policy" {
  role       = aws_iam_role.web_app_role.name
  policy_arn = aws_iam_policy.sns_publish_policy.arn
}

# KMS Access Policy
resource "aws_iam_policy" "kms_access_policy" {
  name        = "${var.vpc_name}_kms_access_policy"
  description = "Policy to allow EC2 instance to use KMS keys"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = [aws_kms_key.ec2_encryption_key.arn, aws_kms_key.s3_encryption_key.arn, aws_kms_key.secrets_encryption_key.arn, aws_kms_key.rds_encryption_key.arn]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_kms_access_policy" {
  role       = aws_iam_role.web_app_role.name
  policy_arn = aws_iam_policy.kms_access_policy.arn
}

resource "aws_iam_policy" "secrets_access_policy" {
  name        = "${var.vpc_name}_secrets_access_policy"
  description = "Policy to allow EC2 instance to access AWS Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = aws_secretsmanager_secret.db_credentials.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_secrets_access_policy" {
  role       = aws_iam_role.web_app_role.name
  policy_arn = aws_iam_policy.secrets_access_policy.arn
}
