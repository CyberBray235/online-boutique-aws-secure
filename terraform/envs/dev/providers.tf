terraform {
  required_version = ">=1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.95.0, <6.0.0"
    }
  }
}

provider "aws" {
  region = var.region_aws
  default_tags {
    tags = {

      Project     = var.nom_du_projet
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "Bray"
    }
  }
}