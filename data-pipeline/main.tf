terraform {
  required_version = "1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.65"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }
  }
}

locals {
  project   = "data-pipeline-infra"
  workspace = terraform.workspace

  common_tags = {
    Workspace = local.workspace
    Project   = local.project
    Prefix    = "${local.project}-${local.workspace}"
    ManagedBy = "terraform"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

module "storage" {
  source = "./storage"
}

module "glue" {
  source = "./glue"

  raw_bucket       = module.storage.raw_bucket
  processed_bucket = module.storage.processed_bucket
}

module "athena" {
  source = "./athena"

  glue_database = module.glue.glue_database
}
