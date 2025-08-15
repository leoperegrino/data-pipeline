resource "random_id" "dms_target" {
  byte_length = 8
}

# trivy:ignore:avd-aws-0088  encryption
# trivy:ignore:avd-aws-0089  logging
# trivy:ignore:avd-aws-0090  versioning
# trivy:ignore:avd-aws-0132  kms
# trivy:ignore:s3-bucket-logging
resource "aws_s3_bucket" "dms_target" {
  bucket        = "dms-target-${random_id.dms_target.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "dms_target" {
  bucket = aws_s3_bucket.dms_target.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
