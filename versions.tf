terraform {
  backend "s3" {
    bucket = "terraform-homelab-backup"
    key = "terraform-homelab-backup/terraform_homelab.tfstate"
    region = "us-west-1"
    encrypt = true
  }
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}
