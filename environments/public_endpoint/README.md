# Public endpoint certificate

This root requests a public ACM certificate in us-east-1 for
k8s.whatishenrylisteningto.com, creates its DNS validation CNAME in Cloudflare,
and waits for issuance. It has its own S3 state key and uses the kubernetes
workspace. It does not change the application hostname's current DNS record,
create an ALB, or modify the cluster.

The reusable acm_dns_certificate module covers one hostname. For another
deployment, supply that hostname and its Cloudflare zone ID, using an AWS
provider in the same region as the destination ALB.

## Run

From this directory, authenticate AWS and load CLOUDFLARE_API_TOKEN using the
existing cloudflare-login shell function. The token needs DNS Read and DNS Write
for the selected zone. Never put the token in Terraform files.

```bash
cloudflare-login
terraform init
terraform workspace select kubernetes || terraform workspace new kubernetes
terraform validate
terraform plan
terraform apply
terraform output -raw certificate_arn
```

Review a plan containing three additions: the ACM certificate, validation CNAME,
and certificate validation waiter. Expect no modifications or destruction of
existing infrastructure. Issuance can take several minutes; the waiter times out
after 30 minutes. A failed wait can be retried after correcting DNS or IAM access.

The certificate's private key remains in ACM. The checked-in tfvars contain only
the hostname and public zone identifier. Provider checksums are copied from the
existing Cloudflare root, preserving the already selected AWS 6.67.0 and
Cloudflare 5.24.0 versions.

Keep the DNS validation record in place for renewal. CNAME flattening and
Cloudflare proxying are disabled on this verification record. If an identical
record is already managed elsewhere, import it rather than duplicating ownership.

After issuance, add the output ARN to the app Ingress's certificate-arn
annotation, enable HTTPS 443 and redirect HTTP to HTTPS. Test the ALB directly
with the application's Host name and TLS SNI before changing public DNS. DNS
cutover and retirement of the previous tunnel configuration are separate steps.
Do not copy the certificate private key or a Cloudflare API token into Kubernetes.

CI validates configuration and checks the module using mock providers. Actual
certificate issuance, AWS permissions, DNS propagation, and HTTPS must be
verified during provisioning.
