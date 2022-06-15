output "this_iam_policy_arn" {
  description = "The IAM policy ARN"
  value       = element(concat(aws_iam_policy.create_policy.*.arn, [""]), 0)
}

