variable "personal_site_com_dns_enabled" {
  description = "Publish henryfranco.com only after direct ALB HTTPS verification."
  type        = bool
  default     = false
}

data "cloudflare_zones" "personal_site_com" {
  name   = "henryfranco.com"
  status = "active"

  lifecycle {
    postcondition {
      condition     = length(self.result) == 1
      error_message = "The Cloudflare token must have Zone Read access to exactly one active henryfranco.com zone."
    }
  }
}

locals {
  personal_site_com_zone_id = one(data.cloudflare_zones.personal_site_com.result).id
}

module "personal_site_com_certificate" {
  source             = "../../modules/acm_dns_certificate"
  hostname           = "henryfranco.com"
  cloudflare_zone_id = local.personal_site_com_zone_id
}

# Read only the apex, leaving mail, TXT, NS and other domain records alone.
data "cloudflare_dns_records" "personal_site_com_apex" {
  zone_id = local.personal_site_com_zone_id
  name = {
    exact = "henryfranco.com"
  }

  lifecycle {
    postcondition {
      condition = length([
        for record in self.result : record.id
        if contains(["A", "AAAA", "CNAME"], record.type)
      ]) <= 1 && alltrue([for record in self.result : record.type != "AAAA"])
      error_message = "Review the existing apex records before cutover: only zero or one A/CNAME record is supported, with no AAAA record."
    }
  }
}

locals {
  personal_site_com_existing_records = [
    for record in data.cloudflare_dns_records.personal_site_com_apex.result : record
    if contains(["A", "CNAME"], record.type)
  ]
}

resource "cloudflare_dns_record" "personal_site_com" {
  count   = var.personal_site_com_dns_enabled ? 1 : 0
  zone_id = local.personal_site_com_zone_id
  name    = "henryfranco.com"
  type    = "CNAME"
  content = local.application_alb_hostname
  ttl     = 1
  proxied = true
  comment = "Managed by Terraform: personal site on AWS ALB"

  depends_on = [module.personal_site_com_certificate]
}

# Adopt an existing apex A/CNAME before changing its target. A-to-CNAME is
# a replacement with this provider; the plan makes that cutover explicit.
import {
  for_each = var.personal_site_com_dns_enabled ? {
    for record in local.personal_site_com_existing_records : "apex" => record.id
  } : {}
  to = cloudflare_dns_record.personal_site_com[0]
  id = "${local.personal_site_com_zone_id}/${each.value}"
}

output "personal_site_com_certificate_arn" {
  description = "Issued henryfranco.com ACM certificate for ALB hostname discovery."
  value       = module.personal_site_com_certificate.certificate_arn
}

output "personal_site_com_zone_id" {
  description = "Existing Cloudflare zone discovered by domain name."
  value       = local.personal_site_com_zone_id
}

output "personal_site_com_existing_apex" {
  description = "Current apex web records; save these before enabling the DNS cutover."
  value = [
    for record in local.personal_site_com_existing_records : {
      id      = record.id
      type    = record.type
      content = record.content
      proxied = record.proxied
      ttl     = record.ttl
    }
  ]
}
