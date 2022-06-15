output "this_iam_role_arn" {
  description = "The IAM role ARN"
  value       = element(concat(aws_iam_role.create_role.*.arn, [""]), 0)
}

