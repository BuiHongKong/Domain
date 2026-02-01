# -----------------------------------------------------------------------------
# Provider configuration
# -----------------------------------------------------------------------------
# Declares which cloud provider Terraform will use. Required before any
# aws_* resources. Configure authentication via environment variables:
#   AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION
# or use: aws configure
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
