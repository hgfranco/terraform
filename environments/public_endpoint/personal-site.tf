variable "personal_site_dns_enabled" {
  description = "Enable the henryfranco.dev DNS cutover only after direct ALB HTTPS verification."
  type        = bool
  default     = false
}

variable "personal_site_alb_name" {
  description = "Existing Kubernetes-managed ALB name; Terraform reads but does not own this ALB."
  type        = string
  default     = "k8s-spotifyn-spotifyn-d41800ca80"
}

data "aws_route53_zone" "personal_site" {
  name         = "henryfranco.dev."
  private_zone = false

  lifecycle {
    postcondition {
      condition = toset(self.name_servers) == toset([
        "ns-579.awsdns-08.net", "ns-2039.awsdns-62.co.uk",
        "ns-1330.awsdns-38.org", "ns-175.awsdns-21.com"
      ])
      error_message = "The selected Route 53 zone must match the domain's authoritative nameservers."
    }
  }
}

resource "aws_acm_certificate" "personal_site" {
  domain_name       = "henryfranco.dev"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "personal_site_validation" {
  for_each = {
    for option in aws_acm_certificate.personal_site.domain_validation_options :
    option.domain_name => {
      name  = option.resource_record_name
      type  = option.resource_record_type
      value = option.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.personal_site.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.value]
}

resource "aws_acm_certificate_validation" "personal_site" {
  certificate_arn         = aws_acm_certificate.personal_site.arn
  validation_record_fqdns = [for record in aws_route53_record.personal_site_validation : record.fqdn]
}

data "aws_lb" "personal_site" {
  count = var.personal_site_dns_enabled ? 1 : 0
  name  = var.personal_site_alb_name
}

resource "aws_route53_record" "personal_site" {
  count   = var.personal_site_dns_enabled ? 1 : 0
  zone_id = data.aws_route53_zone.personal_site.zone_id
  name    = "henryfranco.dev"
  type    = "A"

  alias {
    name                   = data.aws_lb.personal_site[0].dns_name
    zone_id                = data.aws_lb.personal_site[0].zone_id
    evaluate_target_health = false
  }

  depends_on = [aws_acm_certificate_validation.personal_site]
}

# Adopt the existing apex A record before updating its target.
import {
  for_each = var.personal_site_dns_enabled ? toset(["henryfranco.dev"]) : toset([])
  to       = aws_route53_record.personal_site[0]
  id       = "${data.aws_route53_zone.personal_site.zone_id}_${each.value}_A"
}

output "personal_site_certificate_arn" {
  description = "Issued ACM certificate discovered by the ALB controller from the Ingress hostname."
  value       = aws_acm_certificate_validation.personal_site.certificate_arn
}

output "personal_site_zone_id" {
  description = "Existing authoritative Route 53 hosted zone."
  value       = data.aws_route53_zone.personal_site.zone_id
}
