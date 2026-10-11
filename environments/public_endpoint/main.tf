module "certificate" {
  source             = "../../modules/acm_dns_certificate"
  hostname           = var.hostname
  cloudflare_zone_id = var.cloudflare_zone_id
}

module "public_certificates" {
  for_each = var.public_hostnames
  source   = "../../modules/acm_dns_certificate"

  hostname           = each.value
  cloudflare_zone_id = var.cloudflare_zone_id
}
