terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  cloud {
    organization = var.organization

    workspaces {
      name = var.workspace
    }
  }
}