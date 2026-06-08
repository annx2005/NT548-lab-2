terraform {
  required_version = ">= 1.10.0"

  backend "s3" {
    key          = "nt548-lab2/requirement-1/terraform.tfstate"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "nt548-lab2"
      ManagedBy = "terraform"
    }
  }
}
