output "certificate_arn" {
  description = "Validated certificate ARN for the Kubernetes Ingress HTTPS listener."
  value       = module.certificate.certificate_arn
}

output "application_url" {
  description = "Public HTTPS application URL."
  value       = "https://${cloudflare_dns_record.application.name}"
}
