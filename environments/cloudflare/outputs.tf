output "public_url" {
  description = "Application URL; becomes available after the Kubernetes connector is installed."
  value       = "https://${module.tunnel.hostname}"
}

output "tunnel_id" {
  description = "Tunnel ID for identifying the connector in Cloudflare."
  value       = module.tunnel.tunnel_id
}

output "tunnel_token_secret_arn" {
  description = "AWS Secrets Manager ARN containing the TUNNEL_TOKEN JSON field."
  value       = aws_secretsmanager_secret.tunnel_token.arn
}
