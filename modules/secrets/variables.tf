variable "secretsmanager_name" {
  description = "Friendly name of the new secret"
}

variable "secretsmanager_description" {
  description = "Description of the secret"
}

variable "secretsmanager_recovery_window_in_days" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery"
}

variable "secretsmanager_string_api_key" {
  description = "Key-value pairs from JSON back into a native Terraform map"
}
