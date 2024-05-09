terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.48.0"
    }
  }
  required_version = ">=0.15.1"
}

provider "aws" {
  region = var.aws_region
}
