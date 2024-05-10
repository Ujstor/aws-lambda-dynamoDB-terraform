terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.48.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">=2.4.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
  }
  required_version = ">=0.15.1"
}

provider "aws" {
  region = var.aws_region
}
