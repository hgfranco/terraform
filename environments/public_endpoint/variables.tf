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
