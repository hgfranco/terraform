variable "shared_alb_dns_enabled" {
  description = "Switch all application DNS to the grouped ALB only after direct HTTPS checks pass."
  type        = bool
  default     = false
}

data "aws_lb" "shared_applications" {
  count = var.shared_alb_dns_enabled ? 1 : 0
  name  = "kubernetes-public-apps"

  lifecycle {
    postcondition {
      condition     = self.load_balancer_type == "application" && !self.internal && lookup(self.tags, "ingress.k8s.aws/stack", "") == "public-applications"
      error_message = "The cutover requires the internet-facing application ALB owned by the public-applications IngressGroup."
    }
  }
}

locals {
  application_alb_hostname         = var.shared_alb_dns_enabled ? data.aws_lb.shared_applications[0].dns_name : var.alb_hostname
  personal_site_effective_alb_name = var.shared_alb_dns_enabled ? "kubernetes-public-apps" : var.personal_site_alb_name
}

output "application_alb_hostname" {
  description = "ALB hostname currently selected for application DNS."
  value       = local.application_alb_hostname
}
