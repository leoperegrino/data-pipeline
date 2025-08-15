variable "aws_region" {
  description = "AWS region to use"
  type        = string
}

variable "database_name" {
  description = "Database name to use in source and target"
  type        = string
}

variable "database_user" {
  description = "Database user to use in source and target"
  type        = string
}

variable "master_password" {
  description = "Master password to use"
  type        = string
  sensitive   = true
}

variable "availability_zone_1" {
  description = "Availability zone for the subnet"
  type        = string
}

variable "availability_zone_2" {
  description = "Availability zone for the subnet"
  type        = string
}
