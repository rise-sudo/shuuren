terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  cloud {}
}

provider "aws" {
  region = "us-east-1"
}