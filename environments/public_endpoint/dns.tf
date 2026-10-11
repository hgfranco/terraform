resource "cloudflare_dns_record" "public_application" {
  for_each = var.public_dns_record_ids

  zone_id = var.cloudflare_zone_id
  name    = each.key
  type    = "CNAME"
  content = local.application_alb_hostname
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
