variable "aws_region" {
  description = "AWS region of the ALB and its ACM certificate."
  type        = string
  default     = "us-east-1"
}

variable "hostname" {
  description = "Public application hostname covered by the certificate."
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone containing the hostname; this ID is not a credential."
  type        = string
}

variable "alb_hostname" {
  description = "AWS-generated ALB DNS hostname; update if the Ingress recreates the ALB."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]+\\.elb\\.amazonaws\\.com$", var.alb_hostname))
    error_message = "Provide the ALB DNS hostname without a scheme, path, or port."
  }
}

variable "existing_dns_record_id" {
  description = "Existing Cloudflare DNS record ID to import, or null for a new hostname."
  type        = string
  default     = null

  validation {
    condition     = var.existing_dns_record_id == null ? true : can(regex("^[a-f0-9]{32}$", var.existing_dns_record_id))
    error_message = "Provide the 32-character DNS record ID or null."
  }
}

variable "public_hostnames" {
  description = "Additional hostnames in this Cloudflare zone to prepare for ALB HTTPS."
  type        = set(string)
  default     = []

  validation {
    condition     = !contains(var.public_hostnames, var.hostname)
    error_message = "The existing hostname already has its own certificate; list only additional hostnames."
  }
}

variable "public_dns_record_ids" {
  description = "Existing application DNS record IDs by certified hostname for ALB cutover."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for hostname, record_id in var.public_dns_record_ids :
      contains(var.public_hostnames, hostname) && can(regex("^[a-f0-9]{32}$", record_id))
    ])
    error_message = "Each DNS record must have a 32-character ID and a hostname listed in public_hostnames."
  }
}
