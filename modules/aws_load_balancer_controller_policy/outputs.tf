output "policy_arn" {
  description = "Managed policy ARN to attach to a node role or a dedicated controller workload role."
  value       = aws_iam_policy.this.arn
}
