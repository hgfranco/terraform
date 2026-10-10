terraform {
  backend "s3" {
    bucket               = "francotech-terraform-state"
    region               = "us-east-1"
    key                  = "cloudflare/terraform.tfstate"
    workspace_key_prefix = "environments"
    encrypt              = true
    use_lockfile         = true
  }
}
