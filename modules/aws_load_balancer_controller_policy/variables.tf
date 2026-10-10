variable "name" {
  description = "Name of the managed IAM policy."
  type        = string
}

variable "vpc_arn" {
  description = "Cluster VPC ARN used to restrict otherwise unrestricted security-group ingress management."
  type        = string
}

variable "tags" {
  description = "Additional tags for the IAM policy."
  type        = map(string)
  default     = {}
}
