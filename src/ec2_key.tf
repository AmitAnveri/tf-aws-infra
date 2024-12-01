resource "aws_kms_key" "ec2_encryption_key" {
  description             = "Customer managed key for EC2 Auto Scaling encrypted volumes"
  enable_key_rotation     = true
  rotation_period_in_days = 90

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "KeyPolicy",
    Statement : [
      {
        Sid : "AllowRootAccountAccess",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action : "kms:*",
        Resource : "*"
      },
      {
        Sid : "AllowServiceLinkedRoleUse",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
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
      {
        Sid : "AllowGrantCreation",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
        },
        Action : "kms:CreateGrant",
        Resource : "*",
        Condition : {
          Bool : {
            "kms:GrantIsForAWSResource" : true
          }
        }
      }
    ]
  })

  tags = {
    Name = "ec2-encryption-key"
  }
}

data "aws_caller_identity" "current" {}
