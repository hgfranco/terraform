variable "hostname" {
  description = "Single fully qualified hostname covered by the certificate."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*\\.[a-z]{2,}$", var.hostname))
    error_message = "Provide a lowercase DNS hostname without a scheme, path, or wildcard."
  }
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone containing the hostname."
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{32}$", var.cloudflare_zone_id))
    error_message = "Provide the 32-character Cloudflare zone ID."
  }
}

variable "tags" {
  description = "Additional tags for the ACM certificate."
  type        = map(string)
  default     = {}
}
