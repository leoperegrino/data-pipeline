resource "random_id" "raw" {
  byte_length = 8
}

# trivy:ignore:avd-aws-0089  logging
# trivy:ignore:avd-aws-0132  kms
# trivy:ignore:s3-bucket-logging
resource "aws_s3_bucket" "raw" {
  bucket        = "data-pipeline-infra-raw-${random_id.raw.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "raw" {
  bucket = aws_s3_bucket.raw.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "raw" {
  bucket = aws_s3_bucket.raw.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "raw" {
  bucket = aws_s3_bucket.raw.id
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
resource "aws_s3_bucket_server_side_encryption_configuration" "raw" {
  bucket = aws_s3_bucket.raw.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

locals {
  source_dir = "${path.module}/raw"

  files = fileset(local.source_dir, "**")
}

resource "aws_s3_object" "raw" {
  for_each = local.files

  bucket = aws_s3_bucket.raw.id
  key    = each.value
  source = "${local.source_dir}/${each.value}"
  etag   = filemd5("${local.source_dir}/${each.value}")
}
