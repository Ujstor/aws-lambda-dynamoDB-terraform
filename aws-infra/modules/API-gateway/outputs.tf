output "api_gateway_url" {
  value = aws_apigatewayv2_api.my_api.api_endpoint
}
