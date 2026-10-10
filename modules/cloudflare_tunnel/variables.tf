variable "account_id" {
  description = "Cloudflare account containing the tunnel."
  type        = string

  validation {
    condition     = can(regex("^[a-fA-F0-9]{32}$", var.account_id))
    error_message = "Provide a 32-character Cloudflare account ID."
  }
}

variable "zone_id" {
  description = "Cloudflare DNS zone containing the public hostname."
  type        = string

  validation {
    condition     = can(regex("^[a-fA-F0-9]{32}$", var.zone_id))
    error_message = "Provide a 32-character Cloudflare zone ID."
  }
}

variable "name" {
  description = "Name of the dedicated remotely managed tunnel."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "The tunnel name cannot be empty."
  }
}

variable "hostname" {
  description = "Public fully qualified DNS hostname routed through this tunnel."
  type        = string

  validation {
    condition     = can(regex("^([a-z0-9]([a-z0-9-]*[a-z0-9])?\\.)+[a-z]{2,}$", var.hostname))
    error_message = "Provide a lowercase DNS hostname without a scheme, wildcard, or path."
  }
}

variable "service_url" {
  description = "HTTP or HTTPS origin reachable by the Kubernetes cloudflared connector."
  type        = string

  validation {
    condition     = can(regex("^https?://[^/[:space:]]+/?$", var.service_url))
    error_message = "Provide an HTTP or HTTPS origin URL without a path."
  }
}
