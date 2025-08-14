# glue

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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_glue_catalog_database.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database) | resource |
| [aws_glue_catalog_table.marketing_spend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table) | resource |
| [aws_glue_catalog_table.revenue_and_rewards](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table) | resource |
| [aws_glue_catalog_table.user_touchpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table) | resource |
| [aws_glue_catalog_table.users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table) | resource |
| [aws_glue_crawler.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_crawler) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_processed_bucket"></a> [processed\_bucket](#input\_processed\_bucket) | Bucket containing processed data | <pre>object({<br/>    bucket = string,<br/>    arn    = string,<br/>    id     = string,<br/>  })</pre> | n/a | yes |
| <a name="input_raw_bucket"></a> [raw\_bucket](#input\_raw\_bucket) | Bucket containing raw data | <pre>object({<br/>    bucket = string,<br/>    arn    = string,<br/>    id     = string,<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_glue_database"></a> [glue\_database](#output\_glue\_database) | Database to which the queries belong |
<!-- END_TF_DOCS -->
