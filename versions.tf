terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    random = {                 # needed by audit/cloudtrail.tf
      source  = "hashicorp/random"
    }
  }
}

# Global AWS provider config
provider "aws" {
  region  = var.aws_region
  profile = "admin-terraform"   # the profile you configured earlier
}
