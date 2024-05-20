# output "api_gateway_url" {
#   value = aws_apigatewayv2_api.lambda_api.api_endpoint
# }

output "api_gateway_url" {
  description = "Lambda ARN-s and name"
  value = {
    for key, _ in var.lambda_integration_route_premission :
    key => {
      value = aws_apigatewayv2_api.lambda_api[key].api_endpoint
    }
  }
}

