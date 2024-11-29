provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}
terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }
}