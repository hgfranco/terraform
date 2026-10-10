# Cloudflare Tunnel

Creates one remotely managed tunnel, one HTTP/HTTPS hostname route, a catch-all
404 response, and one proxied CNAME. The caller supplies the Cloudflare provider,
account ID, zone ID, tunnel name, hostname, and origin Service URL.

The sensitive token output is for a caller's secret manager. It is stored in
Terraform state; do not publish state or output the token in logs. This module
does not create Kubernetes resources or modify other DNS records.

The tunnel is protected against accidental destruction with prevent_destroy.
Review that protection before any deliberate teardown.
