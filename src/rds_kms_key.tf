resource "aws_kms_key" "rds_encryption_key" {
  description = "KMS key for RDS encryption"
  rotation_period_in_days = 90
  enable_key_rotation = true
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-default-1",
    Statement : [
      {
        Sid : "Enable IAM User Permissions",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action : "kms:*",
        Resource : "*"
      },
      # Allow RDS to use the key for encryption
      {
        Sid : "Allow RDS Use of the Key",
        Effect : "Allow",
        Principal : {
          Service : "rds.amazonaws.com"
        },
        Action : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource : "*"
      },
      # Allow EC2 instances in the VPC to use the key
      {
        Sid : "Allow EC2 Instances Use of the Key",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.web_app_role.name}"
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
    Name = "${var.vpc_name}_rds_encryption_key"
  }
}


resource "aws_kms_alias" "rds_encryption_key_alias" {
  name          = "alias/${var.vpc_name}_rds_encryption"
  target_key_id = aws_kms_key.rds_encryption_key.id
}
