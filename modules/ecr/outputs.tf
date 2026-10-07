output "repository_url" {
  description = "Repository URL used to push and pull container images."
  value       = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  description = "Repository ARN used in IAM policies."
  value       = aws_ecr_repository.this.arn
}