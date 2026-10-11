module "personal_site_ecr" {
  source          = "../../modules/ecr"
  repository_name = "henryfranco-dev"
}

output "personal_site_repository_url" {
  description = "ECR repository URL for Henry Franco's personal website."
  value       = module.personal_site_ecr.repository_url
}
