variable "apigateway_api_name" {
  description = "The name of the API"
}

variable "apigateway_api_protocol" {
  description = "The API protocol"
}

variable "apigateway_api_target_arn" {
  description = "The target ARN"
}

variable "apigateway_integraton_type" {
  description = "The integration's HTTP method"
}

variable "apigateway_integraton_uri" {
  description = "The URI of the Lambda function for a Lambda proxy integration, when integration_type is AWS_PROXY"
}

variable "apigateway_integration_payload_format_version" {
  description = "The format of the payload sent to an integration"
}

variable "apigateway_route_key" {
  description = "The route key for the route. For HTTP APIs, the route key can be either $default, or a combination of an HTTP method and resource path"
}
