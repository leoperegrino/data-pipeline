output "raw_bucket" {
  value       = module.storage.raw_bucket.bucket
  description = "The raw data bucket."
}

output "processed_bucket" {
  value       = module.storage.processed_bucket.bucket
  description = "The processed data bucket."
}
