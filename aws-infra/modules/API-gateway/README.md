## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.15.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.48.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.48.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.lambda_api](https://registry.terraform.io/providers/hashicorp/aws/5.48.0/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_authorizer.lambda_authorizer](https://registry.terraform.io/providers/hashicorp/aws/5.48.0/docs/resources/apigatewayv2_authorizer) | resource |
| [aws_apigatewayv2_integration.lambda_integration](https://registry.terraform.io/providers/hashicorp/aws/5.48.0/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.route](https://registry.terraform.io/providers/hashicorp/aws/5.48.0/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_stage.lambda](https://registry.terraform.io/providers/hashicorp/aws/5.48.0/docs/resources/apigatewayv2_stage) | resource |
| [aws_cloudwatch_log_group.api_gw](https://registry.terraform.io/providers/hashicorp/aws/5.48.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_permission.apigateway_permission](https://registry.terraform.io/providers/hashicorp/aws/5.48.0/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_gw_conf"></a> [api\_gw\_conf](#input\_api\_gw\_conf) | API Gateway configuration | <pre>object({<br>    name          = string<br>    protocol_type = string<br>  })</pre> | <pre>{<br>  "name": "api-gw",<br>  "protocol_type": "HTTP"<br>}</pre> | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_lambda_integration_route_premission"></a> [lambda\_integration\_route\_premission](#input\_lambda\_integration\_route\_premission) | Lambda integration, route and permission configuration | <pre>map(object({<br>    lambda_invoke_arn                 = string<br>    lambda_func_name                  = string<br>    integration_type                  = string<br>    integration_method                = string<br>    connection_type                   = string<br>    route_key                         = string<br>    statement_id                      = string<br>    action                            = string<br>    principal                         = string<br>    authorizer_type                   = string<br>    authorizer_uri                    = string<br>    indentity_sources                 = set(string)<br>    authorizer_name                   = string<br>    authorizer_payload_format_version = string<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_gateway_url"></a> [api\_gateway\_url](#output\_api\_gateway\_url) | Lambda ARN-s and name |
