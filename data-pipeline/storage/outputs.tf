output "raw_bucket" {
  value       = aws_s3_bucket.raw
  description = "The raw data bucket."
}

output "processed_bucket" {
  value       = aws_s3_bucket.processed
  description = "The processed data bucket."
}
