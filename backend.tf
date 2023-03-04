terraform {
  required_version = "1.3.9"

  required_providers {
    aws = {
      # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
      source  = "hashicorp/aws"
      version = ">= 4.57.0"
    }
  }
}
