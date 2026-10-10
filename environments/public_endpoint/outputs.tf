output "certificate_arn" {
  description = "Validated certificate ARN for the Kubernetes Ingress HTTPS listener."
  value       = module.certificate.certificate_arn
}
