resource "aws_dms_replication_subnet_group" "private" {
  replication_subnet_group_description = "Subnet group for DMS"
  replication_subnet_group_id          = "dms-subnet-group"

  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  # explicit depends_on is needed since this resource doesn't reference the role or policy attachment
  depends_on = [aws_iam_role_policy_attachment.dms_vpc]
}


resource "aws_dms_endpoint" "source" {
  endpoint_id   = "dms-source"
  endpoint_type = "source"
  engine_name   = "postgres"

  database_name = var.database_name
  password      = var.master_password
  port          = 5432
  server_name   = aws_db_instance.dms.endpoint
  username      = var.database_user
}

resource "aws_dms_endpoint" "target" {
  endpoint_id   = "dms-target"
  endpoint_type = "target"
  engine_name   = "s3"

  s3_settings {
    bucket_name             = aws_s3_bucket.dms_target.bucket
    service_access_role_arn = aws_iam_role.dms_s3.arn
    compression_type        = "GZIP"
    data_format             = "parquet"
    bucket_folder           = "data/"
    timestamp_column_name   = "dms_timestamp"
  }

}

resource "aws_dms_replication_config" "serverless" {
  replication_config_identifier = "dms"
  replication_type              = "full-load"

  source_endpoint_arn = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn = aws_dms_endpoint.target.endpoint_arn
  table_mappings      = file("${path.module}/table_mappings.json")

  start_replication = false

  compute_config {
    replication_subnet_group_id = aws_dms_replication_subnet_group.private.replication_subnet_group_id
    max_capacity_units          = "1"
    min_capacity_units          = "1"
    multi_az                    = false
    vpc_security_group_ids      = [aws_security_group.dms_instance.id]
  }
}
