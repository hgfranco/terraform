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

## AWS load balancer migration

The Kubernetes environment adds a second public subnet in us-east-1b and
load-balancer discovery tags to prepare for an AWS Application Load Balancer.
Existing nodes remain in the first subnet in us-east-1a.
The controller IAM permissions, installation, HTTPS certificate, and Ingress
remain separate steps; these network changes do not create an ALB.

The [Cloudflare retirement configuration](environments/cloudflare/README.md)
keeps the original backend and providers for removing the previous tunnel and
token secret after the replacement has been verified. Review its destruction
plan separately from the Kubernetes environment's network plan.

The [public endpoint configuration](environments/public_endpoint/README.md)
requests and validates the ACM certificate for the ALB HTTPS listener. It uses
separate state and leaves application DNS cutover to a later step.
