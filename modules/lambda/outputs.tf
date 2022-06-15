output "this_lambda_arn" {
  description = "The Lambda ARN"
  value       = element(concat(aws_lambda_function.create_lambda.*.arn, [""]), 0)
}

output "this_lambda_invoke_arn" {
  description = "The Lambda Invoke ARN"
  value       = element(concat(aws_lambda_function.create_lambda.*.invoke_arn, [""]), 0)
}


