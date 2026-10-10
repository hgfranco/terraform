mock_provider "cloudflare" {
  override_during = plan

  mock_resource "cloudflare_zero_trust_tunnel_cloudflared" {
    defaults = {
      id = "11111111-2222-4333-8444-555555555555"
    }
  }
}

variables {
  account_id  = "11111111111111111111111111111111"
  zone_id     = "22222222222222222222222222222222"
  name        = "test-tunnel"
  hostname    = "app.example.com"
  service_url = "http://app.apps.svc.cluster.local:80"
}

run "route_only_the_configured_hostname" {
  command = plan

  assert {
    condition     = cloudflare_zero_trust_tunnel_cloudflared_config.this.config.ingress[0].service == var.service_url
    error_message = "The origin must use the configured Kubernetes Service URL."
  }

  assert {
    condition     = cloudflare_zero_trust_tunnel_cloudflared_config.this.config.ingress[0].hostname == var.hostname
    error_message = "Only the configured hostname should match the application route."
  }

  assert {
    condition     = cloudflare_zero_trust_tunnel_cloudflared_config.this.config.ingress[1].service == "http_status:404"
    error_message = "Unmatched hostnames must receive a 404 response."
  }

  assert {
    condition     = cloudflare_dns_record.this.proxied && cloudflare_dns_record.this.type == "CNAME" && cloudflare_dns_record.this.ttl == 1
    error_message = "DNS must be a proxied CNAME with automatic TTL."
  }
}

run "reject_non_http_origins" {
  command = plan

  variables {
    service_url = "ssh://control:22"
  }

  expect_failures = [var.service_url]
}
