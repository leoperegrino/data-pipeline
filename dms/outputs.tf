output "source_dns" {
  description = "DNS of source DB"
  value       = aws_db_instance.dms.endpoint
}

output "target_bucket" {
  description = "Target bucket"
  value       = aws_s3_bucket.dms_target.bucket
}
