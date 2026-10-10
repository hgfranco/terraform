# terraform

###### AWS Terraform modules
- API Gateway
- Auto Scaling
- S3
- CloudWatch
- EC2
- ECS
- EIP
- IAM Policy
- IAM Role
- Lambda
- Random Password
- Route 53
- Security Group
- Secrets

## Cloudflare publishing

[Cloudflare environment](environments/cloudflare/README.md) provisions a dedicated
public hostname for the Kubernetes app using a [reusable tunnel module](modules/cloudflare_tunnel/README.md).
