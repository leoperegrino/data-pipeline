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
  project   = "dms-infra"
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
