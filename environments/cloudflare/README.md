# Retire the Cloudflare Tunnel

This root retains the original backend and providers to retire the tunnel,
route configuration, and AWS token secret/version. Its removed block preserves
the application DNS record that moves to environments/public_endpoint.

## Order of operations

Complete the DNS handoff in ../public_endpoint/README.md first. That procedure
removes only the old CNAME state binding, imports the existing record into the
new root, and updates it to the tested HTTPS ALB. Verify the public application
route before applying this retirement root.

From the Terraform repository root:

```bash
terraform -chdir=environments/cloudflare init
terraform -chdir=environments/cloudflare workspace select kubernetes
terraform -chdir=environments/cloudflare state list
terraform -chdir=environments/cloudflare plan
```

After the DNS handoff, expect 0 to add, 0 to change, and 4 to destroy.
The transferred CNAME must not appear among destructions. If the old binding
still exists, the removed block plans to forget it without deleting DNS, but
complete the documented handoff before retiring the tunnel.

After reviewing the plan:

```bash
terraform -chdir=environments/cloudflare apply
terraform -chdir=environments/cloudflare state list
terraform -chdir=environments/cloudflare plan
```

State should contain no resources and the final plan should report no changes.
The secret retains its 30-day recovery window and is scheduled for deletion.
The bootstrap API credential and Kubernetes cloudflare-tunnel Secret are outside
this state and are not deleted by this operation. The Cloudflare zone, account,
and Render apex/www records are also unaffected.

Keep the backend until retirement is confirmed. Do not delete the S3 state or
its version history; previous versions contain sensitive token data protected
by the private encrypted bucket. GitHub Actions only validates configuration.
