output "this_apigateway_execution_arn" {
  description = "The API Gateway Execution ARN"
  value       = element(concat(aws_apigatewayv2_api.create_api.*.execution_arn, [""]), 0)
}

output "this_apigateway_api_endpoint" {
  description = "The API Gateway API Endpoint"
  value       = element(concat(aws_apigatewayv2_api.create_api.*.api_endpoint, [""]), 0)
}
