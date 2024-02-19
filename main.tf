terraform {
  # Run init/plan/apply with "backend" commented-out (ueses local backend) to provision Resources (Bucket, Table)
  # Then uncomment "backend" and run init, apply after Resources have been created (uses AWS)
  backend "s3" {
    bucket         = "my-tf-test-bucketsergio"
    key            = "tf-infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "sergio_bucket-locking"
    encrypt        = true
  }

  required_version = ">=0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "tf-state" {
  source      = "./modules/tf-state"
 # bucket_name = "cc-tf-state-backend-ci-cd"
}

<<<<<<< HEAD
module "vpc-infra" {
  source = "./modules/vpc"

  # VPC Input Vars
  vpc_cidr             = local.vpc_cidr
  availability_zones   = local.availability_zones
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
}
=======
#module "vpc-infra" {
#  source = "./modules/vpc"
#
#  # VPC Input Vars
#  vpc_cidr             = local.vpc_cidr
#  availability_zones   = local.availability_zones
#  public_subnet_cidrs  = local.public_subnet_cidrs
#  private_subnet_cidrs = local.private_subnet_cidrs
#}
>>>>>>> 3d3a6681f4802ff7536b05cab881839105cab7b0

