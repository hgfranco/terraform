
variable "iam_role_name" {
  description = "The name of the role"
}

variable "iam_role_description" {
  description = "Description of the role"
}

variable "iam_role_assume_role_policy_path" {
  description = "The file path to the role policy"
}

variable "iam_role_policy_arn" {
  description = "The ARN of the policy you want to apply"
}
