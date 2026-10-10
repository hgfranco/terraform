mock_provider "cloudflare" {
  override_during = plan

  mock_resource "cloudflare_zero_trust_tunnel_cloudflared" {
    defaults = {
      id = "11111111-2222-4333-8444-555555555555"
    }
  }

}

mock_provider "aws" {}

override_data {
  target          = module.tunnel.data.cloudflare_zero_trust_tunnel_cloudflared_token.this
  override_during = plan
  values = {
    token = "mock-connector-token-for-offline-testing"
  }
}

variables {
  cloudflare_account_id = "11111111111111111111111111111111"
  cloudflare_zone_id    = "22222222222222222222222222222222"
}

run "store_connector_token_without_exposing_it_as_an_output" {
  command = plan

  assert {
    condition     = output.public_url == "https://k8s.whatishenrylisteningto.com"
    error_message = "The public URL must use the dedicated Kubernetes hostname."
  }

  assert {
    condition     = jsondecode(aws_secretsmanager_secret_version.tunnel_token.secret_string).TUNNEL_TOKEN == module.tunnel.token
    error_message = "The secret must contain the connector token under TUNNEL_TOKEN."
  }

  assert {
    condition     = aws_secretsmanager_secret.tunnel_token.recovery_window_in_days == 30
    error_message = "The token secret must retain its recovery window."
  }
}

run "reject_live_site_hostname" {
  command = plan

  variables {
    public_hostname = "whatishenrylisteningto.com"
  }

  expect_failures = [var.public_hostname]
}

run "reject_live_www_hostname" {
  command = plan

  variables {
    public_hostname = "www.whatishenrylisteningto.com"
  }

  expect_failures = [var.public_hostname]
}
