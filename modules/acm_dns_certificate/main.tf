resource "aws_acm_certificate" "this" {
  domain_name       = var.hostname
  validation_method = "DNS"
  key_algorithm     = "RSA_2048"
  tags              = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  validation = one(aws_acm_certificate.this.domain_validation_options)
}

resource "cloudflare_dns_record" "validation" {
  zone_id = var.cloudflare_zone_id
  name    = trimsuffix(local.validation.resource_record_name, ".")
  type    = local.validation.resource_record_type
  content = trimsuffix(local.validation.resource_record_value, ".")
  ttl     = 60
  proxied = false
  comment = "Managed by Terraform: ACM certificate validation"

  settings = {
    flatten_cname = false
  }
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [cloudflare_dns_record.validation.name]

  timeouts {
    create = "30m"
  }
}
