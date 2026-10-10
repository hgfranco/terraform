# Retirement configuration: retain the original backend until its remaining
# tunnel resources are retired after the public ALB endpoint is verified.

# The application DNS record transfers to environments/public_endpoint.
# Never destroy that record when retiring the old tunnel state.
removed {
  from = module.tunnel.cloudflare_dns_record.this

  lifecycle {
    destroy = false
  }
}
