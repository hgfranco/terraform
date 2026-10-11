# Personal website image repository

This change reuses the ECR module to create henryfranco-dev and permits the existing node role to pull from it. Spotify repository access remains in place. The repository has immutable tags, scan-on-push, encryption, and the module's destruction protection.

The website source and Kubernetes workload files live in https://github.com/hgfranco/henryfranco.dev on build-personal-site.

## Review and apply

Use the existing Kubernetes root and kubernetes workspace. Run terraform init, terraform validate, and terraform plan. Expect one ECR repository creation and an in-place update of the node role's inline image-pull policy. Do not apply if the plan proposes replacing nodes or deleting resources.

After review, run terraform apply. Read the new repository URL with:

```bash
terraform output -raw personal_site_repository_url
```

Build and push the website as linux/amd64, using a unique tag. The existing ECR credential provider uses the node IAM role when kubelet pulls images. No Kubernetes image-pull Secret is needed.

This branch does not create a certificate, change DNS, add an ALB, or alter the running Kubernetes application. Those steps need the verified DNS provider and ALB arrangement.
