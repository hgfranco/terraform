output "certificate_arn" {
  description = "Validated certificate ARN for the Kubernetes Ingress HTTPS listener."
  value       = module.certificate.certificate_arn
}

output "application_url" {
  description = "Public HTTPS application URL."
  value       = "https://${cloudflare_dns_record.application.name}"
}

output "public_certificate_arns" {
  description = "Validated ACM certificate ARNs by hostname for the ALB HTTPS listener."
  value       = { for hostname, certificate in module.public_certificates : hostname => certificate.certificate_arn }
}
