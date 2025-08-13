# AWS Terraform Data Pipeline POCs

## POCs

1. [Data Pipeline Infrastructure](./data-pipeline/)

2. [SQL Analytics](./analytics/)

## Develop

```bash
# if nix based development
# $ nix develop path:. -vL
pre-commit install-hooks
```

## Plan and Cost Breakdown

### Infracost

```
Project: main

 Name                                              Monthly Qty  Unit                    Monthly Cost   
                                                                                                       
 module.glue.aws_glue_catalog_database.this                                                            
 ├─ Storage                                  Monthly cost depends on usage: $1.00 per 100k objects     
 └─ Requests                                 Monthly cost depends on usage: $1.00 per 1M requests      
                                                                                                       
 module.glue.aws_glue_crawler.this                                                                     
 └─ Duration                                 Monthly cost depends on usage: $0.69 per hours            
                                                                                                       
 module.storage.aws_s3_bucket.processed                                                                
 └─ Standard                                                                                           
    ├─ Storage                               Monthly cost depends on usage: $0.0405 per GB             
    ├─ PUT, COPY, POST, LIST requests        Monthly cost depends on usage: $0.007 per 1k requests     
    ├─ GET, SELECT, and all other requests   Monthly cost depends on usage: $0.00056 per 1k requests   
    ├─ Select data scanned                   Monthly cost depends on usage: $0.004 per GB              
    └─ Select data returned                  Monthly cost depends on usage: $0.0014 per GB             
                                                                                                       
 module.storage.aws_s3_bucket.raw                                                                      
 └─ Standard                                                                                           
    ├─ Storage                               Monthly cost depends on usage: $0.0405 per GB             
    ├─ PUT, COPY, POST, LIST requests        Monthly cost depends on usage: $0.007 per 1k requests     
    ├─ GET, SELECT, and all other requests   Monthly cost depends on usage: $0.00056 per 1k requests   
    ├─ Select data scanned                   Monthly cost depends on usage: $0.004 per GB              
    └─ Select data returned                  Monthly cost depends on usage: $0.0014 per GB             
                                                                                                       
 OVERALL TOTAL                                                                                $0.00 

*Usage costs can be estimated by updating Infracost Cloud settings, see docs for other options.

──────────────────────────────────
23 cloud resources were detected:
∙ 4 were estimated
∙ 19 were free

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━┓
┃ Project                                            ┃ Baseline cost ┃ Usage cost* ┃ Total cost ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━╋━━━━━━━━━━━━┫
┃ main                                               ┃         $0.00 ┃           - ┃      $0.00 ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━┻━━━━━━━━━━━━┛
```

### Plan

```

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.glue.aws_glue_catalog_database.this will be created
  + resource "aws_glue_catalog_database" "this" {
      + arn          = (known after apply)
      + catalog_id   = (known after apply)
      + description  = "Database for the data pipeline"
      + id           = (known after apply)
      + location_uri = (known after apply)
      + name         = "data-pipeline-infra"
      + tags_all     = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "data-pipeline-infra-default"
          + "Project"   = "data-pipeline-infra"
          + "Workspace" = "default"
        }

      + create_table_default_permission (known after apply)
    }

  # module.glue.aws_glue_catalog_table.marketing_spend will be created
  + resource "aws_glue_catalog_table" "marketing_spend" {
      + arn           = (known after apply)
      + catalog_id    = (known after apply)
      + database_name = "data-pipeline-infra"
      + description   = "Marketing spend data with campaign performance metrics"
      + id            = (known after apply)
      + name          = "marketing_spend"
      + parameters    = {
          + "classification"         = "csv"
          + "skip.header.line.count" = "1"
        }
      + table_type    = "EXTERNAL_TABLE"

      + partition_index (known after apply)

      + storage_descriptor {
          + input_format  = "org.apache.hadoop.mapred.TextInputFormat"
          + location      = (known after apply)
          + output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

          + columns {
              + comment = "Date of marketing activity"
              + name    = "date"
              + type    = "string"
            }
          + columns {
              + comment = "Marketing channel (e.g., google, facebook, instagram)"
              + name    = "channel"
              + type    = "string"
            }
          + columns {
              + comment = "Campaign name"
              + name    = "campaign"
              + type    = "string"
            }
          + columns {
              + comment = "Daily spend amount in USD"
              + name    = "spend"
              + type    = "double"
            }
          + columns {
              + comment = "Number of ad impressions"
              + name    = "impressions"
              + type    = "bigint"
            }
          + columns {
              + comment = "Number of ad clicks"
              + name    = "clicks"
              + type    = "bigint"
            }
          + columns {
              + comment = "Number of app installs"
              + name    = "installs"
              + type    = "bigint"
            }

          + ser_de_info {
              + name                  = "csv-serde"
              + parameters            = {
                  + "separatorChar" = ","
                }
              + serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
            }
        }
    }

  # module.glue.aws_glue_catalog_table.revenue_and_rewards will be created
  + resource "aws_glue_catalog_table" "revenue_and_rewards" {
      + arn           = (known after apply)
      + catalog_id    = (known after apply)
      + database_name = "data-pipeline-infra"
      + description   = "User revenue transactions and bitcoin rewards data"
      + id            = (known after apply)
      + name          = "revenue_and_rewards"
      + parameters    = {
          + "classification"         = "csv"
          + "skip.header.line.count" = "1"
        }
      + table_type    = "EXTERNAL_TABLE"

      + partition_index (known after apply)

      + storage_descriptor {
          + input_format  = "org.apache.hadoop.mapred.TextInputFormat"
          + location      = (known after apply)
          + output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

          + columns {
              + comment = "User identifier"
              + name    = "user_id"
              + type    = "string"
            }
          + columns {
              + comment = "Transaction date"
              + name    = "date"
              + type    = "string"
            }
          + columns {
              + comment = "Revenue amount in USD"
              + name    = "revenue"
              + type    = "double"
            }
          + columns {
              + comment = "Bitcoin rewards given to user (in satoshis or BTC)"
              + name    = "reward_to_user"
              + type    = "double"
            }

          + ser_de_info {
              + name                  = "csv-serde"
              + parameters            = {
                  + "separatorChar" = ","
                }
              + serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
            }
        }
    }

  # module.glue.aws_glue_catalog_table.user_touchpoints will be created
  + resource "aws_glue_catalog_table" "user_touchpoints" {
      + arn           = (known after apply)
      + catalog_id    = (known after apply)
      + database_name = "data-pipeline-infra"
      + description   = "User interaction touchpoints and attribution data"
      + id            = (known after apply)
      + name          = "user_touchpoints"
      + parameters    = {
          + "classification"         = "csv"
          + "skip.header.line.count" = "1"
        }
      + table_type    = "EXTERNAL_TABLE"

      + partition_index (known after apply)

      + storage_descriptor {
          + input_format  = "org.apache.hadoop.mapred.TextInputFormat"
          + location      = (known after apply)
          + output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

          + columns {
              + comment = "User identifier"
              + name    = "user_id"
              + type    = "string"
            }
          + columns {
              + comment = "Timestamp of user interaction"
              + name    = "touchpoint_date"
              + type    = "string"
            }
          + columns {
              + comment = "Marketing channel for this touchpoint"
              + name    = "channel"
              + type    = "string"
            }
          + columns {
              + comment = "Campaign name for this touchpoint"
              + name    = "campaign"
              + type    = "string"
            }
          + columns {
              + comment = "Type of interaction (ad_impression, ad_click, install, etc.)"
              + name    = "touchpoint_type"
              + type    = "string"
            }
          + columns {
              + comment = "Traffic source (utm_source equivalent)"
              + name    = "source"
              + type    = "string"
            }
          + columns {
              + comment = "Traffic medium (utm_medium equivalent)"
              + name    = "medium"
              + type    = "string"
            }
          + columns {
              + comment = "Boolean flag indicating if this touchpoint led to a conversion"
              + name    = "conversion"
              + type    = "boolean"
            }

          + ser_de_info {
              + name                  = "csv-serde"
              + parameters            = {
                  + "separatorChar" = ","
                }
              + serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
            }
        }
    }

  # module.glue.aws_glue_catalog_table.users will be created
  + resource "aws_glue_catalog_table" "users" {
      + arn           = (known after apply)
      + catalog_id    = (known after apply)
      + database_name = "data-pipeline-infra"
      + description   = "User account information and acquisition data"
      + id            = (known after apply)
      + name          = "users"
      + parameters    = {
          + "classification"         = "csv"
          + "skip.header.line.count" = "1"
        }
      + table_type    = "EXTERNAL_TABLE"

      + partition_index (known after apply)

      + storage_descriptor {
          + input_format  = "org.apache.hadoop.mapred.TextInputFormat"
          + location      = (known after apply)
          + output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

          + columns {
              + comment = "Unique user identifier"
              + name    = "user_id"
              + type    = "string"
            }
          + columns {
              + comment = "Timestamp of app installation"
              + name    = "installed_at"
              + type    = "string"
            }
          + columns {
              + comment = "Account creation timestamp"
              + name    = "created_at"
              + type    = "string"
            }
          + columns {
              + comment = "Last account update timestamp"
              + name    = "updated_at"
              + type    = "string"
            }
          + columns {
              + comment = "User acquisition channel"
              + name    = "channel"
              + type    = "string"
            }
          + columns {
              + comment = "User acquisition campaign"
              + name    = "campaign"
              + type    = "string"
            }

          + ser_de_info {
              + name                  = "csv-serde"
              + parameters            = {
                  + "separatorChar" = ","
                }
              + serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
            }
        }
    }

  # module.glue.aws_glue_crawler.this will be created
  + resource "aws_glue_crawler" "this" {
      + arn           = (known after apply)
      + database_name = "data-pipeline-infra"
      + description   = "Crawler for raw data in S3"
      + id            = (known after apply)
      + name          = "data-pipeline-crawler"
      + role          = (known after apply)
      + tags_all      = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "data-pipeline-infra-default"
          + "Project"   = "data-pipeline-infra"
          + "Workspace" = "default"
        }

      + s3_target {
          + path = (known after apply)
        }
    }

  # module.glue.aws_iam_policy.this will be created
  + resource "aws_iam_policy" "this" {
      + arn              = (known after apply)
      + attachment_count = (known after apply)
      + id               = (known after apply)
      + name             = "GlueServicePolicy"
      + name_prefix      = (known after apply)
      + path             = "/"
      + policy           = (known after apply)
      + policy_id        = (known after apply)
      + tags_all         = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "data-pipeline-infra-default"
          + "Project"   = "data-pipeline-infra"
          + "Workspace" = "default"
        }
    }

  # module.glue.aws_iam_role.this will be created
  + resource "aws_iam_role" "this" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "glue.amazonaws.com"
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "GlueServiceRole"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "data-pipeline-infra-default"
          + "Project"   = "data-pipeline-infra"
          + "Workspace" = "default"
        }
      + unique_id             = (known after apply)

      + inline_policy (known after apply)
    }

  # module.glue.aws_iam_role_policy_attachment.this will be created
  + resource "aws_iam_role_policy_attachment" "this" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = "GlueServiceRole"
    }

  # module.storage.aws_s3_bucket.processed will be created
  + resource "aws_s3_bucket" "processed" {
      + acceleration_status         = (known after apply)
      + acl                         = (known after apply)
      + arn                         = (known after apply)
      + bucket                      = (known after apply)
      + bucket_domain_name          = (known after apply)
      + bucket_prefix               = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = true
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + object_lock_enabled         = (known after apply)
      + policy                      = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags_all                    = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "data-pipeline-infra-default"
          + "Project"   = "data-pipeline-infra"
          + "Workspace" = "default"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + cors_rule (known after apply)

      + grant (known after apply)

      + lifecycle_rule (known after apply)

      + logging (known after apply)

      + object_lock_configuration (known after apply)

      + replication_configuration (known after apply)

      + server_side_encryption_configuration (known after apply)

      + versioning (known after apply)

      + website (known after apply)
    }

  # module.storage.aws_s3_bucket.raw will be created
  + resource "aws_s3_bucket" "raw" {
      + acceleration_status         = (known after apply)
      + acl                         = (known after apply)
      + arn                         = (known after apply)
      + bucket                      = (known after apply)
      + bucket_domain_name          = (known after apply)
      + bucket_prefix               = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = true
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + object_lock_enabled         = (known after apply)
      + policy                      = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags_all                    = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "data-pipeline-infra-default"
          + "Project"   = "data-pipeline-infra"
          + "Workspace" = "default"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + cors_rule (known after apply)

      + grant (known after apply)

      + lifecycle_rule (known after apply)

      + logging (known after apply)

      + object_lock_configuration (known after apply)

      + replication_configuration (known after apply)

      + server_side_encryption_configuration (known after apply)

      + versioning (known after apply)

      + website (known after apply)
    }

  # module.storage.aws_s3_bucket_intelligent_tiering_configuration.processed will be created
  + resource "aws_s3_bucket_intelligent_tiering_configuration" "processed" {
      + bucket = (known after apply)
      + id     = (known after apply)
      + name   = "archive-config"
      + status = "Enabled"

      + tiering {
          + access_tier = "ARCHIVE_ACCESS"
          + days        = 90
        }
      + tiering {
          + access_tier = "DEEP_ARCHIVE_ACCESS"
          + days        = 180
        }
    }

  # module.storage.aws_s3_bucket_intelligent_tiering_configuration.raw will be created
  + resource "aws_s3_bucket_intelligent_tiering_configuration" "raw" {
      + bucket = (known after apply)
      + id     = (known after apply)
      + name   = "archive-config"
      + status = "Enabled"

      + tiering {
          + access_tier = "ARCHIVE_ACCESS"
          + days        = 90
        }
      + tiering {
          + access_tier = "DEEP_ARCHIVE_ACCESS"
          + days        = 180
        }
    }

  # module.storage.aws_s3_bucket_public_access_block.processed will be created
  + resource "aws_s3_bucket_public_access_block" "processed" {
      + block_public_acls       = true
      + block_public_policy     = true
      + bucket                  = (known after apply)
      + id                      = (known after apply)
      + ignore_public_acls      = true
      + restrict_public_buckets = true
    }

  # module.storage.aws_s3_bucket_public_access_block.raw will be created
  + resource "aws_s3_bucket_public_access_block" "raw" {
      + block_public_acls       = true
      + block_public_policy     = true
      + bucket                  = (known after apply)
      + id                      = (known after apply)
      + ignore_public_acls      = true
      + restrict_public_buckets = true
    }

  # module.storage.aws_s3_bucket_server_side_encryption_configuration.processed will be created
  + resource "aws_s3_bucket_server_side_encryption_configuration" "processed" {
      + bucket = (known after apply)
      + id     = (known after apply)

      + rule {
          + bucket_key_enabled = true

          + apply_server_side_encryption_by_default {
              + sse_algorithm     = "AES256"
                # (1 unchanged attribute hidden)
            }
        }
    }

  # module.storage.aws_s3_bucket_server_side_encryption_configuration.raw will be created
  + resource "aws_s3_bucket_server_side_encryption_configuration" "raw" {
      + bucket = (known after apply)
      + id     = (known after apply)

      + rule {
          + bucket_key_enabled = true

          + apply_server_side_encryption_by_default {
              + sse_algorithm     = "AES256"
                # (1 unchanged attribute hidden)
            }
        }
    }

  # module.storage.aws_s3_bucket_versioning.processed will be created
  + resource "aws_s3_bucket_versioning" "processed" {
      + bucket = (known after apply)
      + id     = (known after apply)

      + versioning_configuration {
          + mfa_delete = (known after apply)
          + status     = "Enabled"
        }
    }

  # module.storage.aws_s3_bucket_versioning.raw will be created
  + resource "aws_s3_bucket_versioning" "raw" {
      + bucket = (known after apply)
      + id     = (known after apply)

      + versioning_configuration {
          + mfa_delete = (known after apply)
          + status     = "Enabled"
        }
    }

  # module.storage.aws_s3_object.raw["marketing_spend/data.csv"] will be created
  + resource "aws_s3_object" "raw" {
      + acl                    = (known after apply)
      + arn                    = (known after apply)
      + bucket                 = (known after apply)
      + bucket_key_enabled     = (known after apply)
      + checksum_crc32         = (known after apply)
      + checksum_crc32c        = (known after apply)
      + checksum_crc64nvme     = (known after apply)
      + checksum_sha1          = (known after apply)
      + checksum_sha256        = (known after apply)
      + content_type           = (known after apply)
      + etag                   = "6911656b1236053ca19e8cb8b06bf579"
      + force_destroy          = false
      + id                     = (known after apply)
      + key                    = "marketing_spend/data.csv"
      + kms_key_id             = (known after apply)
      + server_side_encryption = (known after apply)
      + source                 = "storage/raw/marketing_spend/data.csv"
      + storage_class          = (known after apply)
      + tags_all               = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "data-pipeline-infra-default"
          + "Project"   = "data-pipeline-infra"
          + "Workspace" = "default"
        }
      + version_id             = (known after apply)
    }

  # module.storage.aws_s3_object.raw["revenue_and_rewards/data.csv"] will be created
  + resource "aws_s3_object" "raw" {
      + acl                    = (known after apply)
      + arn                    = (known after apply)
      + bucket                 = (known after apply)
      + bucket_key_enabled     = (known after apply)
      + checksum_crc32         = (known after apply)
      + checksum_crc32c        = (known after apply)
      + checksum_crc64nvme     = (known after apply)
      + checksum_sha1          = (known after apply)
      + checksum_sha256        = (known after apply)
      + content_type           = (known after apply)
      + etag                   = "018057955fca940b6eab3621626da1b5"
      + force_destroy          = false
      + id                     = (known after apply)
      + key                    = "revenue_and_rewards/data.csv"
      + kms_key_id             = (known after apply)
      + server_side_encryption = (known after apply)
      + source                 = "storage/raw/revenue_and_rewards/data.csv"
      + storage_class          = (known after apply)
      + tags_all               = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "data-pipeline-infra-default"
          + "Project"   = "data-pipeline-infra"
          + "Workspace" = "default"
        }
      + version_id             = (known after apply)
    }

  # module.storage.aws_s3_object.raw["user_touchpoints/data.csv"] will be created
  + resource "aws_s3_object" "raw" {
      + acl                    = (known after apply)
      + arn                    = (known after apply)
      + bucket                 = (known after apply)
      + bucket_key_enabled     = (known after apply)
      + checksum_crc32         = (known after apply)
      + checksum_crc32c        = (known after apply)
      + checksum_crc64nvme     = (known after apply)
      + checksum_sha1          = (known after apply)
      + checksum_sha256        = (known after apply)
      + content_type           = (known after apply)
      + etag                   = "32059d8573495686e2e3d0cd94523e50"
      + force_destroy          = false
      + id                     = (known after apply)
      + key                    = "user_touchpoints/data.csv"
      + kms_key_id             = (known after apply)
      + server_side_encryption = (known after apply)
      + source                 = "storage/raw/user_touchpoints/data.csv"
      + storage_class          = (known after apply)
      + tags_all               = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "data-pipeline-infra-default"
          + "Project"   = "data-pipeline-infra"
          + "Workspace" = "default"
        }
      + version_id             = (known after apply)
    }

  # module.storage.aws_s3_object.raw["users/data.csv"] will be created
  + resource "aws_s3_object" "raw" {
      + acl                    = (known after apply)
      + arn                    = (known after apply)
      + bucket                 = (known after apply)
      + bucket_key_enabled     = (known after apply)
      + checksum_crc32         = (known after apply)
      + checksum_crc32c        = (known after apply)
      + checksum_crc64nvme     = (known after apply)
      + checksum_sha1          = (known after apply)
      + checksum_sha256        = (known after apply)
      + content_type           = (known after apply)
      + etag                   = "97c1c8361de691d92ab6ce8fae0d2fff"
      + force_destroy          = false
      + id                     = (known after apply)
      + key                    = "users/data.csv"
      + kms_key_id             = (known after apply)
      + server_side_encryption = (known after apply)
      + source                 = "storage/raw/users/data.csv"
      + storage_class          = (known after apply)
      + tags_all               = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "data-pipeline-infra-default"
          + "Project"   = "data-pipeline-infra"
          + "Workspace" = "default"
        }
      + version_id             = (known after apply)
    }

  # module.storage.random_id.processed will be created
  + resource "random_id" "processed" {
      + b64_std     = (known after apply)
      + b64_url     = (known after apply)
      + byte_length = 8
      + dec         = (known after apply)
      + hex         = (known after apply)
      + id          = (known after apply)
    }

  # module.storage.random_id.raw will be created
  + resource "random_id" "raw" {
      + b64_std     = (known after apply)
      + b64_url     = (known after apply)
      + byte_length = 8
      + dec         = (known after apply)
      + hex         = (known after apply)
      + id          = (known after apply)
    }

Plan: 25 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + processed_bucket = (known after apply)
  + raw_bucket       = (known after apply)

─────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.
```
