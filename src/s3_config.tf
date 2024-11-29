resource "aws_s3_bucket" "app_images" {
  bucket        = uuid()
  force_destroy = true

  tags = {
    Name = "${var.vpc_name}_app_images_bucket"
  }
}

# Block public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "app_images_block" {
  bucket                  = aws_s3_bucket.app_images.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable server-side encryption for the S3 bucket using the KMS key
resource "aws_s3_bucket_server_side_encryption_configuration" "app_images_encryption" {
  bucket = aws_s3_bucket.app_images.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_encryption_key.arn
    }
  }
}

# Configure the S3 bucket lifecycle policy
resource "aws_s3_bucket_lifecycle_configuration" "app_images_lifecycle" {
  bucket = aws_s3_bucket.app_images.bucket

  rule {
    id     = "transition_to_standard_ia"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}
