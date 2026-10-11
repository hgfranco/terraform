# Cloudflare Tunnel retirement

The tunnel, route configuration and AWS connector-token secret/version have
already been retired. This root retains its original backend and providers so
the existing state history stays accessible.

The application CNAME was previously handed off to the public endpoint root.
That unused subdomain is now retired there after the Kubernetes Ingress drops
its route and TLS certificate. Do not recreate a tunnel or DNS binding here.

```bash
terraform -chdir=environments/cloudflare init
terraform -chdir=environments/cloudflare workspace select kubernetes
terraform -chdir=environments/cloudflare state list
terraform -chdir=environments/cloudflare plan
```

After completed retirement, state should contain no managed resources and the
plan should report no changes. The removed block preserves the previous source
ownership handoff without deleting DNS from this root.

Do not delete the S3 state or its version history; earlier versions contain
connector tokens protected by the private encrypted bucket. The Cloudflare zone
and account are retained. GitHub Actions only validates configuration.
