resource "random_id" "processed" {
  byte_length = 8
}

# trivy:ignore:avd-aws-0089  logging
# trivy:ignore:avd-aws-0132  kms
# trivy:ignore:s3-bucket-logging
resource "aws_s3_bucket" "processed" {
  bucket        = "data-pipeline-infra-processed-${random_id.processed.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "processed" {
  bucket = aws_s3_bucket.processed.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "processed" {
  bucket = aws_s3_bucket.processed.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "processed" {
  bucket = aws_s3_bucket.processed.id
  name   = "archive-config"
  status = "Enabled"

  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
}

# trivy:ignore:avd-aws-0132  customer key
resource "aws_s3_bucket_server_side_encryption_configuration" "processed" {
  bucket = aws_s3_bucket.processed.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}
