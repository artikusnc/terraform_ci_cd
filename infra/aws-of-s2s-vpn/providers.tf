terraform {
  required_version = ">= 1.3.7"

  required_providers {
    aws = {
      region = "us-east-1"
      source  = "hashicorp/aws"
      version = "~> 5.38.0"
    }
  }
}