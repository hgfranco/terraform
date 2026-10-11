variable "aws_region" {
  description = "AWS region of the ALB and its ACM certificate."
  type        = string
  default     = "us-east-1"
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

variable "public_hostnames" {
  description = "Application hostnames in this Cloudflare zone to prepare for ALB HTTPS."
  type        = set(string)
  default     = []

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
