terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket         = "326347646211-sites-tfstate"
    key            = "sites/state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "sites-tfstate-lock"
  }
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 2.54.0"
}

locals {
  prefix = "${var.prefix}-${terraform.workspace}"

  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }
}