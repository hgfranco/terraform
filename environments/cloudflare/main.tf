module "tunnel" {
  source      = "../../modules/cloudflare_tunnel"
  account_id  = var.cloudflare_account_id
  zone_id     = var.cloudflare_zone_id
  name        = var.tunnel_name
  hostname    = var.public_hostname
  service_url = var.service_url
}

resource "aws_secretsmanager_secret" "tunnel_token" {
  name                    = var.tunnel_token_secret_name
  description             = "Cloudflare connector token for ${var.public_hostname}"
  recovery_window_in_days = 30

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_secretsmanager_secret_version" "tunnel_token" {
  secret_id     = aws_secretsmanager_secret.tunnel_token.id
  secret_string = jsonencode({ TUNNEL_TOKEN = module.tunnel.token })
}
