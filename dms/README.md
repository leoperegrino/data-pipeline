# dms

## Plan and Cost Breakdown

### Infracost

<details>
  <summary>Expand</summary>

```
Project: main

 Name                                                            Monthly Qty  Unit                    Monthly Cost   
                                                                                                                     
 aws_db_instance.dms                                                                                                 
 ├─ Database instance (on-demand, Single-AZ, db.t3.micro)                730  hours                         $27.74   
 └─ Storage (general purpose SSD, gp2)                                    20  GB                             $4.38   
                                                                                                                     
 aws_s3_bucket.dms_target                                                                                            
 └─ Standard                                                                                                         
    ├─ Storage                                             Monthly cost depends on usage: $0.0405 per GB             
    ├─ PUT, COPY, POST, LIST requests                      Monthly cost depends on usage: $0.007 per 1k requests     
    ├─ GET, SELECT, and all other requests                 Monthly cost depends on usage: $0.00056 per 1k requests   
    ├─ Select data scanned                                 Monthly cost depends on usage: $0.004 per GB              
    └─ Select data returned                                Monthly cost depends on usage: $0.0014 per GB             
                                                                                                                     
 OVERALL TOTAL                                                                                             $32.12 

*Usage costs can be estimated by updating Infracost Cloud settings, see docs for other options.

──────────────────────────────────
21 cloud resources were detected:
∙ 2 were estimated
∙ 18 were free
∙ 1 is not supported yet, rerun with --show-skipped to see details

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━┓
┃ Project                                            ┃ Baseline cost ┃ Usage cost* ┃ Total cost ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━╋━━━━━━━━━━━━┫
┃ main                                               ┃           $32 ┃           - ┃        $32 ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━┻━━━━━━━━━━━━┛
```

</details>

### Plan

<details>
  <summary>Expand</summary>

```
    Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_db_instance.dms will be created
  + resource "aws_db_instance" "dms" {
      + address                               = (known after apply)
      + allocated_storage                     = 20
      + apply_immediately                     = false
      + arn                                   = (known after apply)
      + auto_minor_version_upgrade            = true
      + availability_zone                     = (known after apply)
      + backup_retention_period               = (known after apply)
      + backup_target                         = (known after apply)
      + backup_window                         = (known after apply)
      + ca_cert_identifier                    = (known after apply)
      + character_set_name                    = (known after apply)
      + copy_tags_to_snapshot                 = false
      + database_insights_mode                = (known after apply)
      + db_name                               = "my_db"
      + db_subnet_group_name                  = "dms-subnet-group"
      + dedicated_log_volume                  = false
      + delete_automated_backups              = true
      + domain_fqdn                           = (known after apply)
      + endpoint                              = (known after apply)
      + engine                                = "postgres"
      + engine_lifecycle_support              = (known after apply)
      + engine_version                        = "17.4"
      + engine_version_actual                 = (known after apply)
      + hosted_zone_id                        = (known after apply)
      + id                                    = (known after apply)
      + identifier                            = "dms"
      + identifier_prefix                     = (known after apply)
      + instance_class                        = "db.t3.micro"
      + iops                                  = (known after apply)
      + kms_key_id                            = (known after apply)
      + latest_restorable_time                = (known after apply)
      + license_model                         = (known after apply)
      + listener_endpoint                     = (known after apply)
      + maintenance_window                    = (known after apply)
      + master_user_secret                    = (known after apply)
      + master_user_secret_kms_key_id         = (known after apply)
      + max_allocated_storage                 = 20
      + monitoring_interval                   = 0
      + monitoring_role_arn                   = (known after apply)
      + multi_az                              = false
      + nchar_character_set_name              = (known after apply)
      + network_type                          = (known after apply)
      + option_group_name                     = (known after apply)
      + parameter_group_name                  = "postgres-dms-params"
      + password                              = (sensitive value)
      + password_wo                           = (write-only attribute)
      + performance_insights_enabled          = false
      + performance_insights_kms_key_id       = (known after apply)
      + performance_insights_retention_period = (known after apply)
      + port                                  = (known after apply)
      + publicly_accessible                   = false
      + replica_mode                          = (known after apply)
      + replicas                              = (known after apply)
      + resource_id                           = (known after apply)
      + skip_final_snapshot                   = true
      + snapshot_identifier                   = (known after apply)
      + status                                = (known after apply)
      + storage_throughput                    = (known after apply)
      + storage_type                          = "gp2"
      + tags_all                              = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }
      + timezone                              = (known after apply)
      + username                              = "my_user"
      + vpc_security_group_ids                = (known after apply)
    }

  # aws_db_parameter_group.postgres_dms will be created
  + resource "aws_db_parameter_group" "postgres_dms" {
      + arn          = (known after apply)
      + description  = "Managed by Terraform"
      + family       = "postgres17"
      + id           = (known after apply)
      + name         = "postgres-dms-params"
      + name_prefix  = (known after apply)
      + skip_destroy = false
      + tags_all     = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }

      + parameter {
          + apply_method = "pending-reboot"
          + name         = "rds.logical_replication"
          + value        = "1"
        }
    }

  # aws_db_subnet_group.private will be created
  + resource "aws_db_subnet_group" "private" {
      + arn                     = (known after apply)
      + description             = "Managed by Terraform"
      + id                      = (known after apply)
      + name                    = "dms-subnet-group"
      + name_prefix             = (known after apply)
      + subnet_ids              = (known after apply)
      + supported_network_types = (known after apply)
      + tags_all                = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }
      + vpc_id                  = (known after apply)
    }

  # aws_dms_endpoint.source will be created
  + resource "aws_dms_endpoint" "source" {
      + certificate_arn             = (known after apply)
      + database_name               = "my_db"
      + endpoint_arn                = (known after apply)
      + endpoint_id                 = "dms-source"
      + endpoint_type               = "source"
      + engine_name                 = "postgres"
      + extra_connection_attributes = (known after apply)
      + id                          = (known after apply)
      + kms_key_arn                 = (known after apply)
      + password                    = (sensitive value)
      + port                        = 5432
      + server_name                 = (known after apply)
      + ssl_mode                    = (known after apply)
      + tags_all                    = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }
      + username                    = "my_user"

      + redshift_settings (known after apply)
    }

  # aws_dms_endpoint.target will be created
  + resource "aws_dms_endpoint" "target" {
      + certificate_arn             = (known after apply)
      + endpoint_arn                = (known after apply)
      + endpoint_id                 = "dms-target"
      + endpoint_type               = "target"
      + engine_name                 = "s3"
      + extra_connection_attributes = (known after apply)
      + id                          = (known after apply)
      + kms_key_arn                 = (known after apply)
      + ssl_mode                    = (known after apply)
      + tags_all                    = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }

      + redshift_settings (known after apply)

      + s3_settings {
          + add_column_name                             = false
          + bucket_folder                               = "data/"
          + bucket_name                                 = (known after apply)
          + canned_acl_for_objects                      = "none"
          + cdc_inserts_and_updates                     = false
          + cdc_inserts_only                            = false
          + cdc_max_batch_interval                      = 60
          + cdc_min_file_size                           = 32000
          + compression_type                            = "GZIP"
          + csv_delimiter                               = ","
          + csv_null_value                              = "NULL"
          + csv_row_delimiter                           = "\\n"
          + data_format                                 = "parquet"
          + data_page_size                              = 1048576
          + date_partition_delimiter                    = "slash"
          + date_partition_enabled                      = false
          + date_partition_sequence                     = "yyyymmdd"
          + dict_page_size_limit                        = 1048576
          + enable_statistics                           = true
          + encoding_type                               = "rle-dictionary"
          + encryption_mode                             = "SSE_S3"
          + glue_catalog_generation                     = false
          + ignore_header_rows                          = 0
          + include_op_for_full_load                    = false
          + max_file_size                               = 1048576
          + parquet_timestamp_in_millisecond            = false
          + parquet_version                             = "parquet-1-0"
          + preserve_transactions                       = false
          + rfc_4180                                    = true
          + row_group_length                            = 10000
          + service_access_role_arn                     = (known after apply)
          + timestamp_column_name                       = "dms_timestamp"
          + use_csv_no_sup_value                        = false
          + use_task_start_time_for_full_load_timestamp = false
        }
    }

  # aws_dms_replication_config.serverless will be created
  + resource "aws_dms_replication_config" "serverless" {
      + arn                           = (known after apply)
      + id                            = (known after apply)
      + replication_config_identifier = "dms"
      + replication_settings          = (known after apply)
      + replication_type              = "full-load"
      + resource_identifier           = (known after apply)
      + source_endpoint_arn           = (known after apply)
      + start_replication             = false
      + table_mappings                = jsonencode(
            {
              + rules = [
                  + {
                      + filters        = []
                      + object-locator = {
                          + schema-name = "%"
                          + table-name  = "%"
                        }
                      + rule-action    = "include"
                      + rule-id        = 1
                      + rule-name      = "1"
                      + rule-type      = "selection"
                    },
                ]
            }
        )
      + tags_all                      = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }
      + target_endpoint_arn           = (known after apply)

      + compute_config {
          + availability_zone            = (known after apply)
          + kms_key_id                   = (known after apply)
          + max_capacity_units           = 1
          + min_capacity_units           = 1
          + multi_az                     = false
          + preferred_maintenance_window = (known after apply)
          + replication_subnet_group_id  = "dms-subnet-group"
          + vpc_security_group_ids       = (known after apply)
        }
    }

  # aws_dms_replication_subnet_group.private will be created
  + resource "aws_dms_replication_subnet_group" "private" {
      + id                                   = (known after apply)
      + replication_subnet_group_arn         = (known after apply)
      + replication_subnet_group_description = "Subnet group for DMS"
      + replication_subnet_group_id          = "dms-subnet-group"
      + subnet_ids                           = (known after apply)
      + tags_all                             = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }
      + vpc_id                               = (known after apply)
    }

  # aws_iam_policy.dms_s3 will be created
  + resource "aws_iam_policy" "dms_s3" {
      + arn              = (known after apply)
      + attachment_count = (known after apply)
      + id               = (known after apply)
      + name             = "dms-s3-policy"
      + name_prefix      = (known after apply)
      + path             = "/"
      + policy           = (known after apply)
      + policy_id        = (known after apply)
      + tags_all         = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }
    }

  # aws_iam_role.dms_s3 will be created
  + resource "aws_iam_role" "dms_s3" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "dms.amazonaws.com"
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
      + name                  = "dms-s3-role"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }
      + unique_id             = (known after apply)

      + inline_policy (known after apply)
    }

  # aws_iam_role.dms_vpc will be created
  + resource "aws_iam_role" "dms_vpc" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "dms.amazonaws.com"
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + description           = "Allows DMS to manage VPC"
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "dms-vpc-role"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }
      + unique_id             = (known after apply)

      + inline_policy (known after apply)
    }

  # aws_iam_role_policy_attachment.dms_vpc will be created
  + resource "aws_iam_role_policy_attachment" "dms_vpc" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
      + role       = "dms-vpc-role"
    }

  # aws_iam_role_policy_attachment.this will be created
  + resource "aws_iam_role_policy_attachment" "this" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = "dms-s3-role"
    }

  # aws_s3_bucket.dms_target will be created
  + resource "aws_s3_bucket" "dms_target" {
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
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
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

  # aws_s3_bucket_public_access_block.dms_target will be created
  + resource "aws_s3_bucket_public_access_block" "dms_target" {
      + block_public_acls       = true
      + block_public_policy     = true
      + bucket                  = (known after apply)
      + id                      = (known after apply)
      + ignore_public_acls      = true
      + restrict_public_buckets = true
    }

  # aws_security_group.dms_instance will be created
  + resource "aws_security_group" "dms_instance" {
      + arn                    = (known after apply)
      + description            = "Security group for DMS instance"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "dms-instance"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_security_group.dms_source will be created
  + resource "aws_security_group" "dms_source" {
      + arn                    = (known after apply)
      + description            = "Security group for the source"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "dms-source"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_subnet.private_1 will be created
  + resource "aws_subnet" "private_1" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "sa-east-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.10.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags_all                                       = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_subnet.private_2 will be created
  + resource "aws_subnet" "private_2" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "sa-east-1b"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.10.2.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags_all                                       = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_vpc.dms will be created
  + resource "aws_vpc" "dms" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.10.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags_all                             = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }
    }

  # aws_vpc_security_group_egress_rule.dms_instance_5432_egress will be created
  + resource "aws_vpc_security_group_egress_rule" "dms_instance_5432_egress" {
      + arn                    = (known after apply)
      + cidr_ipv4              = "10.10.0.0/16"
      + description            = "Allow port 5432 outbound traffic"
      + from_port              = 5432
      + id                     = (known after apply)
      + ip_protocol            = "tcp"
      + security_group_id      = (known after apply)
      + security_group_rule_id = (known after apply)
      + tags_all               = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }
      + to_port                = 5432
    }

  # aws_vpc_security_group_ingress_rule.dms_source_5432_ingress will be created
  + resource "aws_vpc_security_group_ingress_rule" "dms_source_5432_ingress" {
      + arn                    = (known after apply)
      + cidr_ipv4              = "10.10.0.0/16"
      + description            = "Allow port 5432 inbound traffic"
      + from_port              = 5432
      + id                     = (known after apply)
      + ip_protocol            = "tcp"
      + security_group_id      = (known after apply)
      + security_group_rule_id = (known after apply)
      + tags_all               = {
          + "ManagedBy" = "terraform"
          + "Prefix"    = "dms-infra-default"
          + "Project"   = "dms-infra"
          + "Workspace" = "default"
        }
      + to_port                = 5432
    }

  # random_id.dms_target will be created
  + resource "random_id" "dms_target" {
      + b64_std     = (known after apply)
      + b64_url     = (known after apply)
      + byte_length = 8
      + dec         = (known after apply)
      + hex         = (known after apply)
      + id          = (known after apply)
    }

Plan: 22 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + source_dns    = (known after apply)
  + target_bucket = (known after apply)

─────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.
```

</details>

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.12.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.65 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.dms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.postgres_dms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_dms_endpoint.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_endpoint) | resource |
| [aws_dms_endpoint.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_endpoint) | resource |
| [aws_dms_replication_config.serverless](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_config) | resource |
| [aws_dms_replication_subnet_group.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_subnet_group) | resource |
| [aws_iam_policy.dms_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.dms_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.dms_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.dms_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.dms_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.dms_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_security_group.dms_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.dms_source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.dms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_security_group_egress_rule.dms_instance_5432_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.dms_source_5432_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [random_id.dms_target](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone_1"></a> [availability\_zone\_1](#input\_availability\_zone\_1) | Availability zone for the subnet | `string` | n/a | yes |
| <a name="input_availability_zone_2"></a> [availability\_zone\_2](#input\_availability\_zone\_2) | Availability zone for the subnet | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to use | `string` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Database name to use in source and target | `string` | n/a | yes |
| <a name="input_database_user"></a> [database\_user](#input\_database\_user) | Database user to use in source and target | `string` | n/a | yes |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | Master password to use | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_source_dns"></a> [source\_dns](#output\_source\_dns) | DNS of source DB |
| <a name="output_target_bucket"></a> [target\_bucket](#output\_target\_bucket) | Target bucket |
<!-- END_TF_DOCS -->
