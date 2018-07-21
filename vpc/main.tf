provider "aws" {
  region = "us-west-1"
  profile = "${var.profile}"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.37.0"

  name = "rg-staging"

  cidr = "10.0.0.0/16"

  azs             = ["us-west-1a", "us-west-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "rg-public-subnet"
  }

  tags = {
    Owner       = "hfranco"
    Environment = "staging"
  }

  vpc_tags = {
    Name = "vpc-rg-staging"
  }
}
