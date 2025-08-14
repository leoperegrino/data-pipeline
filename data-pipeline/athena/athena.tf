resource "aws_athena_workgroup" "data_pipeline" {
  name = "data_pipeline"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_results.bucket}/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }

  force_destroy = true
}

locals {
  source_dir = "${path.module}/sql"

  files = fileset(local.source_dir, "**")
}

resource "aws_athena_named_query" "sql" {
  for_each = local.files

  name      = each.value
  workgroup = aws_athena_workgroup.data_pipeline.id
  database  = var.glue_database
  query     = file("${path.module}/sql/${each.value}")
}
