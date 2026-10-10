# Public Kubernetes application through Cloudflare

Public URL: https://k8s.whatishenrylisteningto.com

Traffic will flow from Cloudflare through a cloudflared Pod to the existing
spotify-now-playing Service on port 80. Terraform creates the tunnel, its route,
the subdomain's proxied CNAME, and an AWS Secrets Manager secret/version. The
Kubernetes connector is installed separately; the URL will not work until it
connects. No load balancer, inbound EC2 rule, or application change is required.

This directory has its own S3 state key, cloudflare/terraform.tfstate. It does
not read or modify the Kubernetes environment's infrastructure/terraform.tfstate.
Use the kubernetes workspace in both directories; the distinct keys keep the
resources separate. The apex and www live-site hostnames are rejected.

## Credentials and IDs

The Cloudflare domain must be active. Copy its account ID and zone ID from the
Cloudflare dashboard. These IDs are not secrets. Supply them without committing
credentials:

```bash
export TF_VAR_cloudflare_account_id="YOUR_ACCOUNT_ID"
export TF_VAR_cloudflare_zone_id="YOUR_ZONE_ID"
```

Create a Cloudflare API token scoped to this account and this DNS zone with:
- Account / Cloudflare Tunnel / Edit
- Zone / DNS / Edit

Store that API token as a **plain-text** AWS Secrets Manager secret named
cloudflare/terraform/api-token in us-east-1 using the AWS console. This bootstrap
credential is separate from the connector token Terraform will create. The
existing application's CF_API_TOKEN may not have the tunnel-management permissions.

Load the API credential into the current shell from AWS Secrets Manager:

```bash
export CLOUDFLARE_API_TOKEN="$(aws secretsmanager get-secret-value \
  --region us-east-1 \
  --secret-id cloudflare/terraform/api-token \
  --query SecretString --output text)"
```

Do not put API credentials in .tfvars, Git, or Terraform outputs. The AWS CLI
and Terraform use your existing AWS credentials. The applying identity needs
access to the S3 backend and permission to create/update the Secrets Manager
secret, in addition to reading the bootstrap credential.

## Review and provision

From the Terraform repository root:

```bash
cd environments/cloudflare
terraform init
terraform workspace select -or-create kubernetes
terraform workspace show
terraform fmt -check
terraform validate
terraform plan
```

Expect five resources to add: a tunnel, route configuration, DNS record, secret,
and secret version. Do not apply a plan containing changes to existing cluster
resources. If this hostname or secret already exists, import it deliberately
rather than deleting it or creating a second owner.

After reviewing the plan:

```bash
terraform apply
terraform output
unset CLOUDFLARE_API_TOKEN
```

Outputs contain the public URL, tunnel ID, and token-secret ARN, never the token.
Terraform stores the connector token in the secret JSON field **TUNNEL_TOKEN**.
The token is also in Terraform's sensitive state, including versioned S3 history;
the existing private, encrypted state bucket remains part of credential storage.
Secrets Manager storage and requests incur AWS charges.

## Kubernetes handoff

Use the existing namespace spotify-now-playing and a cloudflared Deployment:
- Read TUNNEL_TOKEN from the AWS secret into a Kubernetes Secret.
- Run cloudflared with its token supplied through a Secret, not in the manifest.
- Label the connector Pods **access: spotify** so the existing ingress
  NetworkPolicy admits them to the app on TCP 3000.
- The origin route is
  http://spotify-now-playing.spotify-now-playing.svc.cluster.local:80.
- Use at least two connector replicas for connector availability. The app itself
  remains one replica; do not scale its file-writing workload for this change.
- Permit outbound connections to Cloudflare on port 7844 (TCP/UDP). The existing
  node egress rules already allow outbound traffic.

HTTPS terminates at Cloudflare, the tunnel connection is encrypted, and the final
Pod-to-Service hop uses HTTP on the cluster network. Existing Render DNS and
Spotify OAuth callback configuration remain unchanged.

Stopping all EC2 nodes makes this new hostname unavailable; the tunnel, DNS,
token secret, and application EBS data remain. No EC2 public IP is in the DNS
record, so changing public IPs does not require a Terraform update.

The tunnel and token secret use prevent_destroy. Token rotation must update
both Secrets Manager and the Kubernetes Secret, then restart the connectors.
Cloudflare-side credential rotation is an explicit operational step; Terraform
does not automatically rotate the connector token.

## Offline checks

CI initializes with the backend disabled and runs validate and mocked Terraform
tests without AWS or Cloudflare credentials. These checks verify provider schema,
route behavior, token-secret mapping, and the live-hostname guard. They do not
provision infrastructure or prove the public endpoint works.
