resource "aws_kms_key" "secrets_encryption_key" {
  description             = "KMS key for encrypting secrets in Secrets Manager"
  enable_key_rotation     = true
  rotation_period_in_days = 90

  policy = jsonencode({
    Version : "2012-10-17",
    Id : "SecretsManagerKMSKeyPolicy",
    Statement : [
      {
        Sid : "AllowRootAccess",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action : "kms:*",
        Resource : "*"
      },
      {
        Sid : "AllowSecretsManagerAccess",
        Effect : "Allow",
        Principal : {
          Service : "secretsmanager.amazonaws.com"
        },
        Action : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource : "*"
      },
      {
        Sid : "AllowEC2InstanceAccess",
        Effect : "Allow",
        Principal : {
          AWS : aws_iam_role.web_app_role.arn
        },
        Action : [
          "kms:Decrypt",
          "kms:DescribeKey"
        ],
        Resource : "*"
      }
    ]
  })

  tags = {
    Name = "${var.vpc_name}_secrets_encryption_key"
  }
}
