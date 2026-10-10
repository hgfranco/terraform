variable "cloudflare_account_id" {
  description = "Cloudflare account ID from the domain overview; this is not a credential."
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Zone ID for whatishenrylisteningto.com; this is not a credential."
  type        = string
}

variable "aws_region" {
  description = "AWS region used to store the connector token."
  type        = string
  default     = "us-east-1"
}

variable "tunnel_name" {
  description = "Name of the dedicated tunnel."
  type        = string
  default     = "spotify-now-playing-kubernetes"
}

variable "public_hostname" {
  description = "Separate public hostname for the Kubernetes application."
  type        = string
  default     = "k8s.whatishenrylisteningto.com"

  validation {
    condition = (
      endswith(var.public_hostname, ".whatishenrylisteningto.com") &&
      !contains(["www.whatishenrylisteningto.com"], var.public_hostname)
    )
    error_message = "Use a separate subdomain; the live apex and www hostname are excluded."
  }
}

variable "service_url" {
  description = "Kubernetes Service address reached by the cloudflared Pod."
  type        = string
  default     = "http://spotify-now-playing.spotify-now-playing.svc.cluster.local:80"
}

variable "tunnel_token_secret_name" {
  description = "AWS Secrets Manager secret for the connector token."
  type        = string
  default     = "cloudflare/spotify-now-playing/kubernetes/tunnel"
}
