# Cut over to the grouped application ALB

Companion changes in k8s-infra and henryfranco.dev create the henryfranco
namespace and the public-applications IngressGroup. The controller creates
kubernetes-public-apps alongside the legacy ALB. Do not delete the legacy
Ingress, workload, or ALB during preparation.

Terraform continues using the existing alb_hostname and personal_site_alb_name
while shared_alb_dns_enabled is false. Keep those values for rollback.
The false setting does not require the new ALB to exist and should produce no
DNS changes when applied to the current state. Review a full plan.

## Preparation

1. Merge the three companion PRs. Apply the namespace and website workload,
   then the two grouped Ingresses using k8s-infra's migration guide.
2. Check both Ingresses report the same ALB hostname and all target groups have
   healthy targets. Verify the new website image and both replicas are ready.
3. Test all routes directly against the new ALB, including Spotify /api/status
   and the personal site's /, /about/, /resume/ and /healthz. Public DNS still
   uses the old ALB. Do not proceed if any direct check fails.
4. Initialize this root and select the existing kubernetes workspace.

```bash
terraform -chdir=environments/public_endpoint init
terraform -chdir=environments/public_endpoint workspace select kubernetes
terraform -chdir=environments/public_endpoint plan
```

Do not migrate state, import the ALB, change certificate resources, or use -target.

## DNS cutover

Set shared_alb_dns_enabled = true in terraform.tfvars. Commit that switch through
a follow-up PR after the direct tests pass, then review a full plan.

The enabled switch looks up kubernetes-public-apps and verifies its group tag.
It updates the existing Spotify and henryfranco.com Cloudflare CNAME targets and
the henryfranco.dev Route 53 alias. The existing record resource addresses,
certificates, proxy settings, and domain names stay intact.

Expect three DNS updates in place, data reads, and an output change. Stop if the
plan replaces or destroys any managed resource, creates certificates, or changes
unrelated records. The controller owns the ALBs, so Terraform's plan will not
show their creation or deletion.

```bash
terraform -chdir=environments/public_endpoint plan -out=/tmp/shared-alb-cutover.tfplan
terraform -chdir=environments/public_endpoint apply /tmp/shared-alb-cutover.tfplan
for domain in henryfranco.com henryfranco.dev; do
  for path in / /about/ /resume/ /healthz; do
    curl -fsS --max-time 20 -o /dev/null "https://${domain}${path}"
  done
done
curl -fsS --max-time 20 https://whatishenrylisteningto.com/api/status
```

Cloudflare stays Full (strict); no redirect between personal-site domains.

## Rollback and cleanup

While the legacy Ingress and website workload still exist, set the switch back
to false, review the plan for three reverse DNS updates, and apply. Check all
public routes afterward. Keep the legacy ALB serving throughout resolver cache
propagation and an observation window (at least 24 hours after stable cutover).

Only after that window, use k8s-infra's cleanup instructions to delete the legacy
Ingress and old website workload. The controller then deletes the legacy ALB.
After deletion, setting the switch false is no longer a working rollback:
restore the legacy resources first, wait for their ALB, and update the legacy
ALB inputs if its name or hostname changed before planning a reverse cutover.

Before retiring the old ALB, search Terraform configuration/state for any other
DNS records that reference it, including records outside this root. Update any
additional consumers deliberately.
