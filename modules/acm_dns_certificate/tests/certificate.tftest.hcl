mock_provider "aws" {
  mock_resource "aws_acm_certificate" {
    defaults = {
      arn = "arn:aws:acm:us-east-1:123456789012:certificate/11111111-1111-1111-1111-111111111111"
      domain_validation_options = [
        {
          domain_name           = "app.example.com"
          resource_record_name  = "_validation.app.example.com."
          resource_record_type  = "CNAME"
          resource_record_value = "_target.acm-validations.aws."
        }
      ]
    }
  }
}

mock_provider "cloudflare" {}

variables {
  hostname           = "app.example.com"
  cloudflare_zone_id = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

run "dns_validation" {
  command = apply

  assert {
    condition     = aws_acm_certificate.this.validation_method == "DNS"
    error_message = "Use DNS validation for managed certificate renewal."
  }

  assert {
    condition = (
      cloudflare_dns_record.validation.name == "_validation.app.example.com" &&
      cloudflare_dns_record.validation.content == "_target.acm-validations.aws" &&
      cloudflare_dns_record.validation.type == "CNAME" &&
      cloudflare_dns_record.validation.proxied == false &&
      cloudflare_dns_record.validation.settings.flatten_cname == false
    )
    error_message = "Publish an unproxied, unflattened ACM validation CNAME."
  }

  assert {
    condition     = output.certificate_arn == aws_acm_certificate.this.arn
    error_message = "Expose the certificate ARN after the validation waiter."
  }
}
