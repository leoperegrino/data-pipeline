variable "raw_bucket" {
  type = object({
    bucket = string,
    arn    = string,
    id     = string,
  })
  description = "Bucket containing raw data"
}

variable "processed_bucket" {
  type = object({
    bucket = string,
    arn    = string,
    id     = string,
  })
  description = "Bucket containing processed data"
}
