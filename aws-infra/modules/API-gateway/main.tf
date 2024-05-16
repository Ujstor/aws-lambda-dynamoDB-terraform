resource "aws_apigatewayv2_api" "my_api" {
  name          = var.api_gw_conf.name
  protocol_type = var.api_gw_conf.protocol_type

  cors_configuration {
    allow_headers = ["content-type", "authorization"]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_origins = ["*"]
  }
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.my_api.id

  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.my_api.name}"

  retention_in_days = 30
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  for_each = var.lambda_integration_route_premission

  api_id             = aws_apigatewayv2_api.my_api.id
  integration_type   = each.value.integration_type
  integration_uri    = each.value.lambda_invoke_arn
  integration_method = each.value.integration_method
  connection_type    = each.value.connection_type
}

resource "aws_apigatewayv2_route" "route" {
  for_each = var.lambda_integration_route_premission

  api_id    = aws_apigatewayv2_api.my_api.id
  route_key = each.value.route_key
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration[each.key].id}"
}

resource "aws_lambda_permission" "apigateway_permission" {
  for_each = var.lambda_integration_route_premission

  statement_id  = each.value.statement_id
  action        = each.value.action
  function_name = each.value.lambda_func_name
  principal     = each.value.principal

  source_arn = "${aws_apigatewayv2_api.my_api.execution_arn}/*/*/*"
}

resource "aws_apigatewayv2_authorizer" "lambda_authorizer" {
  for_each = var.lambda_integration_route_premission

  api_id                            = aws_apigatewayv2_api.my_api.id
  authorizer_type                   = each.value.authorizer_type
  authorizer_uri                    = each.value.authorizer_uri
  identity_sources                  = each.value.indentity_sources
  name                              = each.value.authorizer_name
  authorizer_payload_format_version = each.value.authorizer_payload_format_version
}
