output "public_certificate_arns" {
  description = "Validated ACM certificate ARNs by hostname for the ALB HTTPS listener."
  value       = { for hostname, certificate in module.public_certificates : hostname => certificate.certificate_arn }
}

output "public_application_urls" {
  description = "Additional public HTTPS application URLs managed by this root."
  value       = { for hostname, record in cloudflare_dns_record.public_application : hostname => "https://${record.name}" }
}
