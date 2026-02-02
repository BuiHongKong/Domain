# -----------------------------------------------------------------------------
# AWS Budgets - Provider
# -----------------------------------------------------------------------------
# Budgets API is a billing service; us-east-1 is typically used.
# Auth: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, or aws configure
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
