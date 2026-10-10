# AWS Load Balancer Controller IAM policy

Creates a managed policy independently of its role attachment. The Kubernetes
environment attaches it to the existing EC2 node role for the current kubeadm
cluster. A future EKS environment should attach it to a dedicated controller
role using EKS Pod Identity or IRSA instead.

The vendored iam_policy.json is the upstream commercial-partition policy from
[controller v3.6.0](https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/v3.6.0/docs/install/iam_policy.json),
under the included Apache 2.0 license. Changes require explicit review alongside
controller upgrades; no policy is downloaded at Terraform apply time.
This module does not support AWS China or GovCloud policy variants.

The generated policy adds a VPC ARN condition to the upstream unconditional
AuthorizeSecurityGroupIngress/RevokeSecurityGroupIngress statement, as recommended
by the [installation guide](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v3.6/deploy/installation/).
Other upstream permissions and ownership-tag conditions remain unchanged.
The policy still includes wildcard resources and optional controller features;
it is not a policy restricted to a single load balancer.

Attaching this policy grants the node role additional load-balancer and security
group permissions. The current nodes share that role. The upcoming controller
installation must obtain credentials through IMDSv2; use host networking with
explicit region and VPC settings to preserve the existing hop limit.
Ordinary application Pods do not need these credentials.

Terraform creates only the managed policy and the environment's role attachment.
It does not install the controller or create a load balancer. HTTPS certificates,
Ingress and DNS are separate configuration steps.

Supply name and vpc_arn; use policy_arn as the role attachment input.
