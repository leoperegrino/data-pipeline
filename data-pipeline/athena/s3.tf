resource "random_id" "athena_results" {
  byte_length = 8
}

# trivy:ignore:avd-aws-0088  encryption
# trivy:ignore:avd-aws-0089  logging
# trivy:ignore:avd-aws-0090  versioning
# trivy:ignore:avd-aws-0132  kms
# trivy:ignore:s3-bucket-logging
resource "aws_s3_bucket" "athena_results" {
  bucket        = "sql-analytics-athena-results-${random_id.athena_results.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "athena_results" {
  bucket = aws_s3_bucket.athena_results.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
