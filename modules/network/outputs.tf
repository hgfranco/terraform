output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs keyed by availability zone."
  value = {
    for az, subnet in aws_subnet.public : az => subnet.id
  }
}

output "private_subnet_ids" {
  description = "Private subnet IDs keyed by availability zone."
  value = {
    for az, subnet in aws_subnet.private : az => subnet.id
  }
}

output "vpc_arn" {
  description = "ARN of the VPC, for IAM permission conditions."
  value       = aws_vpc.this.arn
}
