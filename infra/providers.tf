terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  cloud {
    organization = "shuuren"

    workspaces {
      name = "shuuren-alpha"
    }
  }
}