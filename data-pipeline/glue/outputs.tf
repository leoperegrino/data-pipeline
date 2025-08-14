output "glue_database" {
  description = "Database to which the queries belong"
  value       = aws_glue_catalog_database.this.name
}
