output "tunnel_id" {
  description = "ID of the remotely managed tunnel."
  value       = cloudflare_zero_trust_tunnel_cloudflared.this.id
}

output "hostname" {
  description = "Public hostname served by this tunnel."
  value       = cloudflare_dns_record.this.name
}

output "token" {
  description = "Connector token; persist in a secret manager rather than printing it."
  value       = data.cloudflare_zero_trust_tunnel_cloudflared_token.this.token
  sensitive   = true
}
