provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "kubernetes"
      ManagedBy = "Terraform"
    }
  }
}

# Authentication comes from CLOUDFLARE_API_TOKEN in the current process.
# Never put the API token in terraform.tfvars or provider configuration.
provider "cloudflare" {}
