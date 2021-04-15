terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.36"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
  profile = "default"
}

module "network" {
  source = "./network"
}

module "eks" {
  source = "./eks"
  public_subnets  = module.network.aws_subnets_public
  private_subnets = module.network.aws_subnets_private
}

module "fargate" {
  source = "./fargate"
  private_subnets = module.network.aws_subnets_private
}
