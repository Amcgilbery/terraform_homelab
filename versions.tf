terraform {
  backend "s3" {
    bucket = "terraform-homelab-backup"
    key = "terraform-homelab-backup/terraform_homelab.tfstate"
    region = "us-west-1"
    encrypt = true
  }
}

provider "aws" {
  region = "us-west-1"
}
