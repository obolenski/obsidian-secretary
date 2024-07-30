provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "obolenski-terraform-state"
    key    = "obsidian-secretary.tfstate"
    region = "eu-central-1"
  }
}

