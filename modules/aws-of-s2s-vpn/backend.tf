terraform {
  backend "s3" {
    bucket = "terraform-of-mgm"
    key    = "management-infra-aws-of-s2s-vpn.tfstate"
    region = "us-east-1"

    role_arn = "arn:aws:iam::007554613773:role/atlantis"
  }
}

provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::007554613773:role/atlantis"
  }

  # https://www.hashicorp.com/blog/default-tags-in-the-terraform-aws-provider
  default_tags {
    tags = {
      org_repo   = "artikusnc/terraform_ci_cd"
      tribe      = "IT"
      squad      = "cloud-runtime"
      path       = "modules-aws-of-s2s-vpn"
      managed_by = "Terraform"
    }
  }
}