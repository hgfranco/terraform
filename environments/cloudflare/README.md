# Retire the Cloudflare Tunnel

The application is moving to an AWS Application Load Balancer. This directory
now declares no managed resources and exists only to retire the previous tunnel
from its original state. It does not provision an ALB or change the Render site.

## Timing and expected changes

Do not apply this directory until the ALB, controller, HTTPS certificate, and
application routing have been verified. The ALB network prerequisites alone
are not a complete replacement.

Applying this root removes the tunnel, its route configuration, its
k8s.whatishenrylisteningto.com CNAME, and the AWS tunnel-token secret/version.
It does not remove the Cloudflare DNS zone, account, or apex/www Render records.
Coordinate removal of the tunnel CNAME with creation of the ALB DNS record;
this retirement configuration does not create the replacement record.

The previous prevent_destroy blocks leave with their resource declarations.
Terraform can therefore plan the deliberate retirement. No state-rm command,
manual resource deletion, or force deletion is needed.

The Secrets Manager secret retains its existing 30-day recovery window.
Terraform schedules its deletion; it is not immediately purged.
The bootstrap API credential cloudflare/terraform/api-token was created outside
this state and is not removed. The Kubernetes Secret cloudflare-tunnel is also
outside this state and requires separate cleanup.

## Retire using the original backend

Keep the existing provider credentials available. The Cloudflare provider reads
CLOUDFLARE_API_TOKEN; AWS uses your normal credential chain.
From the Terraform repository root, after the replacement is ready:

~~~bash
cd environments/cloudflare
terraform init
terraform workspace select kubernetes
terraform workspace show
terraform state list
terraform plan
~~~

This uses the original S3 key cloudflare/terraform.tfstate with workspace prefix
environments. It does not use the Kubernetes infrastructure state.
Select the existing kubernetes workspace; do not create a new empty workspace.

For the previously applied setup, expect 0 to add, 0 to change, and 5 to destroy.
Review any different result before proceeding. In particular, an empty plan
while the tunnel still exists usually means the wrong state or workspace.

After reviewing and coordinating the DNS cutover:

~~~bash
terraform apply
terraform state list
terraform plan
~~~

State should contain no resources and the final plan should report no changes.
Keep this backend configuration until those checks are complete. Do not delete
the S3 state or its version history; old versions contain sensitive token data
and remain governed by the existing private encrypted bucket controls.

Removing this code does not itself perform retirement. GitHub Actions only
checks formatting and validates the configuration with its backend disabled.
