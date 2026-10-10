output "role_arn" {
  description = "ARN of the EC2 IAM role."
  value       = aws_iam_role.this.arn
}

output "instance_profile_name" {
  description = "Instance profile name to attach to EC2 instances."
  value       = aws_iam_instance_profile.this.name
}

output "role_name" {
  description = "Name of the EC2 IAM role for additional policy attachments."
  value       = aws_iam_role.this.name
}
