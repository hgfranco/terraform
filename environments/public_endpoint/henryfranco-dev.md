# henryfranco.dev publication

The public nameservers were verified in GitHub Actions as Route 53. Terraform
discovers the existing public zone by domain and verifies its nameservers.
It creates an apex-only ACM certificate in us-east-1 and its DNS validation record.
No www record, new ALB, or new hosted zone is created.

Use the existing public_endpoint backend and workspace kubernetes. AWS credentials
must have access to this domain's hosted zone, ACM, and read access to the ALB.
The existing Cloudflare configuration still requires CLOUDFLARE_API_TOKEN.

## Stage 1: certificate, with existing website unchanged

Keep personal_site_dns_enabled=false (the default). Run init, select workspace
kubernetes, validate, plan, and apply in this directory. Expect a certificate,
validation CNAME, and certificate validation resource. Check issuance using
terraform output -raw personal_site_certificate_arn.

Apply the website ECR change, publish its linux/amd64 image, deploy its workloads,
and apply the companion shared Ingress PR. Test henryfranco.dev using curl's
--connect-to against the ALB hostname before changing DNS.

## Stage 2: reviewed DNS cutover

Read and save the current Route 53 apex A and AAAA records using the zone ID from
terraform output -raw personal_site_zone_id. The current apex A record is imported
into this state, then updated to an ALB alias. If another Terraform stack manages
that record, remove its ownership there before adopting it here.

Check for an existing AAAA record. This ALB uses IPv4; an old AAAA record must be
removed in a separately reviewed DNS change before cutover, otherwise IPv6 visitors
could reach the old origin. Do not enable cutover until that check is complete.
Also confirm the zone is in the selected AWS account and the A record exists.

Set personal_site_dns_enabled=true in terraform.tfvars through a follow-up PR,
review the import/update plan, then apply. Verify the public homepage and sitemap.
This flag is a deployment gate, not a rollback switch: after cutover, setting it
false plans deletion of the managed A record. Roll back by restoring the saved
record target in configuration and reviewing/applying that change.

The ALB remains owned by Kubernetes. Changing personal_site_alb_name only changes
the discovered DNS target. Keep the old hosting until end-to-end verification
passes. Certificate DNS records must remain for automatic ACM renewal.
