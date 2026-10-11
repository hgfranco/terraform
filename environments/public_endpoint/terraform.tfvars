cloudflare_zone_id = "a8548b270f3f3f742cbf4354dfda2444"
alb_hostname       = "k8s-spotifyn-spotifyn-d41800ca80-205775015.us-east-1.elb.amazonaws.com"

public_hostnames = [
  "whatishenrylisteningto.com",
]

public_dns_record_ids = {
  "whatishenrylisteningto.com" = "d5c0882e9cfbde24f12c1110d9da9d5f"
}

personal_site_dns_enabled = true

# Direct ALB HTTPS checks passed for /, /about/ and /healthz.
personal_site_com_dns_enabled = true

# Keep legacy DNS until the grouped ALB passes direct HTTPS checks.
shared_alb_dns_enabled = false
