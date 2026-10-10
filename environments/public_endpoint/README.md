# Public application endpoint

This root manages the ACM certificate and the proxied Cloudflare CNAME for
k8s.whatishenrylisteningto.com. AWS Load Balancer Controller owns the ALB and
Kubernetes owns the Ingress; Terraform consumes the ALB's published hostname.
The root uses a separate S3 state key and the kubernetes workspace.

The reusable acm_dns_certificate module covers one hostname and validates it
through an unproxied, unflattened DNS CNAME. Use an AWS provider in the same
region as the destination ALB. Keep the validation CNAME for renewal.
The private key remains in ACM.

## Initial DNS handoff

The certificate has been issued and the ALB HTTPS listener has been tested with
the application hostname and TLS SNI. The old Cloudflare state still owns the
application CNAME. Transfer only that record before importing it here; do not
apply the old retirement root until the new public route has been verified.

From the Terraform repository root, with AWS credentials and
CLOUDFLARE_API_TOKEN loaded using cloudflare-login:

```bash
terraform -chdir=environments/cloudflare init
terraform -chdir=environments/cloudflare workspace select kubernetes
terraform -chdir=environments/public_endpoint init
terraform -chdir=environments/public_endpoint workspace select kubernetes
terraform -chdir=environments/public_endpoint validate
terraform -chdir=environments/cloudflare state show 'module.tunnel.cloudflare_dns_record.this'
```

Confirm the old record ID is bb9e71ba176e6992f1a8f3d8f40bbbfc and the hostname
is k8s.whatishenrylisteningto.com. The checked-in import block uses that ID.
Then remove only its old state binding. This command changes Terraform state,
not the live DNS record. Keep other infrastructure changes paused during the
handoff, so another operation cannot reintroduce ownership.

```bash
terraform -chdir=environments/cloudflare state rm 'module.tunnel.cloudflare_dns_record.this'
terraform -chdir=environments/public_endpoint plan
```

Expect 1 to import, 0 to add, 1 to change, 0 to destroy. The existing CNAME keeps
its ID and changes its content from the tunnel hostname to the ALB hostname;
its comment also changes. The certificate and validation record remain unchanged.
Review the plan before applying:

```bash
terraform -chdir=environments/public_endpoint apply
terraform -chdir=environments/public_endpoint plan
curl -fsS https://k8s.whatishenrylisteningto.com/api/status
```

Cloudflare must use Full (strict) SSL/TLS for this hostname so it verifies the
ALB's ACM certificate. This configuration does not change zone-wide SSL
settings, which may affect other sites. Check the existing setting in Cloudflare
and configure Full (strict), using a hostname-specific configuration rule if
the rest of the zone requires a different setting.

If the import or apply fails after state removal, the DNS record stays live
but unmanaged. Retry the import in this root before proceeding with tunnel
retirement. Do not create a duplicate CNAME or delete the existing record.
Keep the import block as migration history; it is ignored once the record is
already managed at the destination address.

## Later changes

If Kubernetes recreates the ALB, retrieve its new Ingress ADDRESS, update
alb_hostname, and apply this root. The checked-in IDs and hostname are public
configuration, not credentials. Never put API tokens in tfvars.
The Cloudflare API token needs DNS Read and DNS Write for this zone.

For a new deployment without an existing application CNAME, set
existing_dns_record_id to null. Initial provisioning adds the certificate,
validation record, validation waiter, and application CNAME.

After public HTTPS works, retire the old tunnel using the original Cloudflare
root. Its removed block preserves the migrated CNAME. The root should then
plan four managed-resource destructions for the tunnel, configuration, and
token secret/version. See ../cloudflare/README.md.

CI validates configuration and tests certificate DNS validation with mock
providers. Live DNS ownership, AWS permissions, certificate issuance,
Cloudflare TLS mode, and end-to-end HTTPS require provisioning checks.
