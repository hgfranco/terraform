module "certificate" {
  source             = "../../modules/acm_dns_certificate"
  hostname           = var.hostname
  cloudflare_zone_id = var.cloudflare_zone_id
}
