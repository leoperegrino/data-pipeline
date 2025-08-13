resource "aws_glue_catalog_database" "this" {
  name        = "data-pipeline-infra"
  description = "Database for the data pipeline"
}

resource "aws_glue_crawler" "this" {
  database_name = aws_glue_catalog_database.this.name
  name          = "data-pipeline-crawler"
  role          = aws_iam_role.this.arn
  description   = "Crawler for raw data in S3"

  s3_target {
    path = "s3://${var.raw_bucket.bucket}/"
  }
}

resource "aws_glue_catalog_table" "marketing_spend" {
  name          = "marketing_spend"
  database_name = aws_glue_catalog_database.this.name
  description   = "Marketing spend data with campaign performance metrics"

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "classification"         = "csv"
    "skip.header.line.count" = "1"
  }

  storage_descriptor {
    location      = "s3://${var.raw_bucket.bucket}/marketing_spend/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "csv-serde"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "separatorChar" = ","
      }
    }

    columns {
      name    = "date"
      type    = "string"
      comment = "Date of marketing activity"
    }
    columns {
      name    = "channel"
      type    = "string"
      comment = "Marketing channel (e.g., google, facebook, instagram)"
    }
    columns {
      name    = "campaign"
      type    = "string"
      comment = "Campaign name"
    }
    columns {
      name    = "spend"
      type    = "double"
      comment = "Daily spend amount in USD"
    }
    columns {
      name    = "impressions"
      type    = "bigint"
      comment = "Number of ad impressions"
    }
    columns {
      name    = "clicks"
      type    = "bigint"
      comment = "Number of ad clicks"
    }
    columns {
      name    = "installs"
      type    = "bigint"
      comment = "Number of app installs"
    }
  }
}

resource "aws_glue_catalog_table" "users" {
  name          = "users"
  database_name = aws_glue_catalog_database.this.name
  description   = "User account information and acquisition data"

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "classification"         = "csv"
    "skip.header.line.count" = "1"
  }

  storage_descriptor {
    location      = "s3://${var.raw_bucket.bucket}/users/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "csv-serde"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "separatorChar" = ","
      }
    }

    columns {
      name    = "user_id"
      type    = "string"
      comment = "Unique user identifier"
    }
    columns {
      name    = "installed_at"
      type    = "string"
      comment = "Timestamp of app installation"
    }
    columns {
      name    = "created_at"
      type    = "string"
      comment = "Account creation timestamp"
    }
    columns {
      name    = "updated_at"
      type    = "string"
      comment = "Last account update timestamp"
    }
    columns {
      name    = "channel"
      type    = "string"
      comment = "User acquisition channel"
    }
    columns {
      name    = "campaign"
      type    = "string"
      comment = "User acquisition campaign"
    }
  }
}

resource "aws_glue_catalog_table" "user_touchpoints" {
  name          = "user_touchpoints"
  database_name = aws_glue_catalog_database.this.name
  description   = "User interaction touchpoints and attribution data"

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "classification"         = "csv"
    "skip.header.line.count" = "1"
  }

  storage_descriptor {
    location      = "s3://${var.raw_bucket.bucket}/user_touchpoints/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "csv-serde"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "separatorChar" = ","
      }
    }

    columns {
      name    = "user_id"
      type    = "string"
      comment = "User identifier"
    }
    columns {
      name    = "touchpoint_date"
      type    = "string"
      comment = "Timestamp of user interaction"
    }
    columns {
      name    = "channel"
      type    = "string"
      comment = "Marketing channel for this touchpoint"
    }
    columns {
      name    = "campaign"
      type    = "string"
      comment = "Campaign name for this touchpoint"
    }
    columns {
      name    = "touchpoint_type"
      type    = "string"
      comment = "Type of interaction (ad_impression, ad_click, install, etc.)"
    }
    columns {
      name    = "source"
      type    = "string"
      comment = "Traffic source (utm_source equivalent)"
    }
    columns {
      name    = "medium"
      type    = "string"
      comment = "Traffic medium (utm_medium equivalent)"
    }
    columns {
      name    = "conversion"
      type    = "boolean"
      comment = "Boolean flag indicating if this touchpoint led to a conversion"
    }
  }
}

resource "aws_glue_catalog_table" "revenue_and_rewards" {
  name          = "revenue_and_rewards"
  database_name = aws_glue_catalog_database.this.name
  description   = "User revenue transactions and bitcoin rewards data"

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "classification"         = "csv"
    "skip.header.line.count" = "1"
  }

  storage_descriptor {
    location      = "s3://${var.raw_bucket.bucket}/revenue_and_rewards/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "csv-serde"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "separatorChar" = ","
      }
    }

    columns {
      name    = "user_id"
      type    = "string"
      comment = "User identifier"
    }
    columns {
      name    = "date"
      type    = "string"
      comment = "Transaction date"
    }
    columns {
      name    = "revenue"
      type    = "double"
      comment = "Revenue amount in USD"
    }
    columns {
      name    = "reward_to_user"
      type    = "double"
      comment = "Bitcoin rewards given to user (in satoshis or BTC)"
    }
  }
}
