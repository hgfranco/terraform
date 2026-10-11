# Serve henryfranco.com alongside henryfranco.dev

Both hostnames serve the existing henryfranco-dev Service and application Pods.
Visitors keep the hostname they entered. No domain redirect or www hostname is added.
The site's existing henryfranco.dev canonical metadata remains the preferred search
URL; it does not redirect visitors.

## Certificate first

Run this in environments/public_endpoint using the existing kubernetes workspace.
The Cloudflare token needs Zone Read and DNS Edit access to henryfranco.com, in
addition to its existing zone permissions. The zone ID is discovered by name.

```bash
terraform init
terraform workspace select kubernetes
terraform plan -target=module.personal_site_com_certificate
terraform apply -target=module.personal_site_com_certificate
```

The retired Spotify certificate may still be attached because the Ingress cannot
reconcile until the .com certificate exists. Use the targeted certificate step
above to break that dependency; it does not run the merged retirement deletions.
After the new certificate is issued, wait for Ingress reconciliation and confirm
the retired certificate has no InUseBy associations before a full plan/apply.

Keep personal_site_com_dns_enabled false for this first apply. It creates and
validates the ACM certificate in us-east-1, but leaves the apex website destination
unchanged. The ACM validation CNAME stays unproxied for certificate renewal.
If a matching validation record already exists, import it into
module.personal_site_com_certificate.cloudflare_dns_record.validation before
applying rather than overwriting it.

## Route and verify

Merge and apply the companion k8s-infra Ingress change after the certificate is
ISSUED. It adds henryfranco.com to certificate discovery and sends its requests to
the same Service as henryfranco.dev, on the existing ALB.

```bash
ALB_HOST=$(kubectl get ingress spotify-now-playing -n spotify-now-playing -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
curl -fsS --connect-to "henryfranco.com:443:${ALB_HOST}:443" https://henryfranco.com/healthz
curl -fsS --connect-to "henryfranco.com:443:${ALB_HOST}:443" https://henryfranco.com/
curl -fsS --connect-to "henryfranco.com:443:${ALB_HOST}:443" https://henryfranco.com/about/
```

## Publish DNS

After direct HTTPS checks succeed and the retired certificate is detached, run
a full plan and apply with DNS still disabled. Review the retired-resource
deletions, then save the current apex values before cutover:

```bash
terraform plan
terraform apply
terraform output -json personal_site_com_existing_apex > /tmp/henryfranco-com-dns-before.json
```

Then set personal_site_com_dns_enabled = true in
terraform.tfvars through a follow-up PR, then review and apply the plan. Terraform
imports the existing apex A/CNAME automatically if present. Changing an A record
to CNAME replaces that one record; an existing CNAME is updated. Multiple apex web
records or an AAAA record stop the plan for review. MX, TXT, NS, subdomains and
henryfranco.dev are unaffected.

The new proxied CNAME points to the existing ALB. Cloudflare SSL/TLS must use
Full (strict) for the issued origin certificate. Check existing Cloudflare
Redirect Rules, Page Rules or Workers if .com currently redirects; DNS and
Ingress changes do not remove those separate rules.

```bash
curl -i --max-time 20 https://henryfranco.com/
curl -i --max-time 20 https://henryfranco.com/about/
curl -fsS --max-time 20 https://henryfranco.dev/healthz
```

Confirm both domains work and .com does not return a Location header pointing at
.dev. HTTP-to-HTTPS and the /about to /about/ path normalization may still redirect
within the same hostname. Save the pre-cutover record values for rollback; merely
turning the DNS switch off would delete the managed apex record, not restore its
old target.
