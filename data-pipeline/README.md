# data-pipeline

## Storage Module

This Terraform module provisions S3 buckets for data storage with security best
practices and proper configuration for a data pipeline.

The storage module creates two S3 buckets:

- **Raw Bucket**: For storing incoming raw data files (CSV, JSON, etc.)
- **Processed Bucket**: For storing transformed and processed data (Parquet, etc.)

Both buckets are configured with:

- **Server-side encryption**: AES256 encryption at rest
- **Public access blocked**: All public access is denied
- **Versioning**: Object versioning enabled for data protection
- **Unique naming**: Random suffixes prevent bucket name conflicts
- **Intelligent Tiering**: Moves objects betweeen cost tiers based on access patterns

### Usage

```hcl
module "storage" {
  source = "/path/to/storage_module"
}
```

## Glue Module

This module provisions the Glue resources, the IAM roles/policies for
interacting with the raw bucket and Glue itself, the dummy data created to test
the solution.

The Glue resources are:
1. Catalog Database
1. Glue Crawler
1. Catalog Tables

The module has one variable that should be passed from the storage module which is
the raw bucket object.


### Usage

```hcl
module "glue" {
  source = "/path/to/glue_module"

  raw_bucket = module.storage.raw_bucket
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.12.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.65 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.3 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_glue"></a> [glue](#module\_glue) | ./glue | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | ./storage | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to use. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_processed_bucket"></a> [processed\_bucket](#output\_processed\_bucket) | The processed data bucket. |
| <a name="output_raw_bucket"></a> [raw\_bucket](#output\_raw\_bucket) | The raw data bucket. |
<!-- END_TF_DOCS -->
