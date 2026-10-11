# Public application endpoints

This root manages ACM certificates and DNS for the public application domains.
AWS Load Balancer Controller owns the ALB and Kubernetes owns the shared Ingress.
Terraform consumes the ALB's published hostname. Use the existing S3 backend and
the kubernetes workspace.

- whatishenrylisteningto.com: Cloudflare certificate validation and proxied CNAME.
- henryfranco.dev: Route 53 certificate validation and ALB alias.
- henryfranco.com: Cloudflare certificate validation and staged DNS publication;
  see henryfranco-com.md after the companion certificate PR is merged.

No www hostname is configured. The reusable acm_dns_certificate module validates
one hostname through an unproxied, unflattened CNAME. Keep validation records for
certificate renewal and use ACM in the ALB's region.

## Retire the unused Spotify subdomain

Apply this cleanup only after the shared Ingress has dropped the retired
subdomain from its TLS hosts and routing rules and the controller has detached
its certificate. If deploying henryfranco.com at the same time, first apply the
certificate configuration from Terraform PR #23, then the Ingress from
k8s-infra PR #2, and finally this cleanup.

This removes the old cloudflare_dns_record.application and module.certificate,
including its dedicated ACM certificate, validation CNAME and validation waiter.
It also removes their unused inputs and outputs. The active apex resource
addresses remain unchanged. No ALB, Service, Pod or apex domain is deleted.

```bash
terraform -chdir=environments/public_endpoint init
terraform -chdir=environments/public_endpoint workspace select kubernetes
terraform -chdir=environments/public_endpoint plan
```

When the retired resources are still present in state, expect four resource
destructions: the unused application CNAME and the three dedicated certificate
module resources. The plan must preserve public_application and
public_certificates entries for the active Spotify domain, plus personal-site
resources. Review the plan before applying.

```bash
terraform -chdir=environments/public_endpoint apply
curl -fsS https://whatishenrylisteningto.com/api/status
curl -fsS https://henryfranco.dev/healthz
```

ACM refuses deletion while the certificate remains associated with an ALB
listener. Wait for Ingress reconciliation before applying; do not delete the ALB
or modify active certificates to force retirement.

## DNS and later changes

The Spotify apex A record was imported and replaced with a proxied ALB CNAME.
Its original A record ID remains in the import block as migration history; the
block is ignored while the destination already exists in this environment's
state. Use the existing backend and workspace rather than importing the deleted
historical A record into a new state.

Cloudflare must use Full (strict) SSL/TLS for the application hostnames. API tokens
need DNS Read and DNS Write for the managed zones, plus Zone Read for .com lookup.
Never put credentials in tfvars. If Kubernetes recreates the ALB, update
alb_hostname and apply this root.

The original Cloudflare tunnel and connector secret have been retired. The old
root is retained to preserve state history; see ../cloudflare/README.md.

CI validates configuration and tests DNS certificate validation with mock
providers. Live DNS, certificate associations and public HTTPS are verified
during deployment.

## Application namespace migration

See [shared-alb-migration.md](shared-alb-migration.md). The new DNS switch defaults
to false and is explicitly false in terraform.tfvars. Terraform only reads the
controller-owned ALB; it does not create, retag, import, or delete it.
