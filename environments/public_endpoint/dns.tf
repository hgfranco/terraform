resource "cloudflare_dns_record" "application" {
  zone_id = var.cloudflare_zone_id
  name    = var.hostname
  type    = "CNAME"
  content = var.alb_hostname
  ttl     = 1
  proxied = true
  comment = "Managed by Terraform: AWS ALB application endpoint"

  settings = {
    flatten_cname = false
    ipv4_only     = false
    ipv6_only     = false
  }
}

# Import an existing DNS record for this deployment. Leave the ID null when
# provisioning a new hostname that has no existing record.
import {
  for_each = var.existing_dns_record_id == null ? {} : { application = var.existing_dns_record_id }
  to       = cloudflare_dns_record.application
  id       = "${var.cloudflare_zone_id}/${each.value}"
}

resource "cloudflare_dns_record" "public_application" {
  for_each = var.public_dns_record_ids

  zone_id = var.cloudflare_zone_id
  name    = each.key
  type    = "CNAME"
  content = var.alb_hostname
  ttl     = 1
  proxied = true
  comment = "Managed by Terraform: AWS ALB application endpoint"

  depends_on = [module.public_certificates]
}

import {
  for_each = var.public_dns_record_ids
  to       = cloudflare_dns_record.public_application[each.key]
  id       = "${var.cloudflare_zone_id}/${each.value}"
}
