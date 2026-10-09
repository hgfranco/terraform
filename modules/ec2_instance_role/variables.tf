variable "name" {
  description = "Name for the EC2 IAM role and instance profile."
  type        = string
}

variable "policy_json" {
  description = "IAM permissions policy JSON attached to the role."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy_json))
    error_message = "policy_json must contain valid JSON."
  }
}

variable "managed_policy_arns" {
  description = "AWS managed or customer managed policy ARNs attached to the role."
  type        = set(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to the IAM role and instance profile."
  type        = map(string)
  default     = {}
}
