resource "aws_apigatewayv2_api" "create_api" {
  name          = var.apigateway_api_name
  protocol_type = var.apigateway_api_protocol
  target        = var.apigateway_api_target_arn
}

resource "aws_apigatewayv2_integration" "create_api_integration" {
  api_id                 = aws_apigatewayv2_api.create_api.id
  integration_type       = var.apigateway_integraton_type
  integration_uri        = var.apigateway_integraton_uri
  payload_format_version = var.apigateway_integration_payload_format_version
}

resource "aws_apigatewayv2_route" "create_api_route" {
  api_id    = aws_apigatewayv2_api.create_api.id
  route_key = var.apigateway_route_key
  target    = "integrations/${aws_apigatewayv2_integration.create_api_integration.id}"
}
