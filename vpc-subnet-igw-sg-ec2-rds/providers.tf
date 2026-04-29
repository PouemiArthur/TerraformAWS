terraform {
  required_providers {
    aws = {
      source = "aws"
      version = "~>5.0"
      }
   }
backend "s3" {
  bucket = "pjr-terraform-state-050426"
  key = "dev2/terraform.tfstate"
  region = "us-east-1"
  dynamodb_table = "PJr-terraform-lock"
  encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}

