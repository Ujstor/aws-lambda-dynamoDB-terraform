# Terrafrom modules for creating lambda functions

![tf_logic](./public/tf_logic.png)

Check modules docs:
 - [Lambda](./aws-infra/modules/lambda/README.md)
 - [DynamoDB](./aws-infra/modules/dynamoDB/README.md)
 - [API-gateway](./aws-infra/modules/API-gateway/README.md)

```tf
module "lambda" {
  source = "./modules/lambda"

  lambda_config = {
    "function1" = {
      work_dir             = "../lambda/"
      bin_name             = "bootstrap"
      archive_bin_name     = "function.zip"
      function_name        = "test-function-1"
      handler              = "main"
      runtime              = "provided.al2023"
      ephemeral_storage    = "512"
      archive_type         = "zip"
      command              = "GOOS=linux GOARCH=amd64 go build -o bootstrap"
      interpreter          = ["/bin/bash", "-c"]
      tag_name             = "dev"
      tag_description      = "createuser"
      tag_function_version = "$LATEST"
    }
  }
}

module "dynamodb" {
  source = "./modules/dynamoDB"

  dynamodb = {
    table1 = {
      name           = "userTable"
      billing_mode   = "PROVISIONED"
      read_capacity  = 5
      write_capacity = 5
      hash_key       = "username"
      attribute = [
        {
          name = "username"
          type = "S"
        },
      ]
      tag_name        = "userTable"
      tag_environment = "Dev"
    },
  }
}

module "api_gateway" {
  source = "./modules/API-gateway"

  lambda_integration_route_premission = {
    my_gw = {
      lambda_invoke_arn                 = module.lambda.lambda_arn["function1"].invoke_arn
      lambda_func_name                  = module.lambda.lambda_arn["function1"].lambda_name
      integration_type                  = "AWS_PROXY"
      integration_method                = "POST"
      connection_type                   = "INTERNET"
      route_key                         = "ANY /{proxy+}"
      statement_id                      = "AllowExecutionFromAPIGateway"
      action                            = "lambda:InvokeFunction"
      principal                         = "apigateway.amazonaws.com"
      authorizer_type                   = "REQUEST"
      authorizer_uri                    = module.lambda.lambda_arn["function1"].invoke_arn
      indentity_sources                 = ["$request.header.Authorization"]
      authorizer_name                   = "example-authorizer"
      authorizer_payload_format_version = "1.0"
    }
  }
}
```

## Terraform output

```bash

module.lambda.null_resource.build-go-bin-trigger["function1"]: Creating...
module.lambda.null_resource.build-go-bin-trigger["function1"]: Provisioning with 'local-exec'...
module.lambda.null_resource.build-go-bin-trigger["function1"] (local-exec): Executing: ["/bin/bash" "-c" "GOOS=linux GOARCH=amd64 go build -o bootstrap"]
module.lambda.null_resource.build-go-bin-trigger["function1"]: Creation complete after 0s [id=3249771435172819715]
module.lambda.data.archive_file.lambda["function1"]: Reading...
module.api_gateway.aws_apigatewayv2_api.my_api: Creating...
module.dynamodb.aws_dynamodb_table.dynamodb-table["table1"]: Creating...
module.lambda.data.archive_file.lambda["function1"]: Read complete after 1s [id=a8b17cc50380b5c45aedd775be195192fcf366df]
module.lambda.aws_iam_policy.dynamodb_policy: Creating...
module.lambda.aws_iam_role.iam_for_lambda: Creating...
module.api_gateway.aws_apigatewayv2_api.my_api: Creation complete after 1s [id=j6qj62s6o3]
module.api_gateway.aws_cloudwatch_log_group.api_gw: Creating...
module.lambda.aws_iam_policy.dynamodb_policy: Creation complete after 1s [id=arn:aws:iam::795062932265:policy/lambda_dynamodb_policy]
module.lambda.aws_iam_role.iam_for_lambda: Creation complete after 1s [id=iam_for_lambda]
module.lambda.aws_iam_role_policy_attachment.dynamodb_policy_attachment: Creating...
module.lambda.aws_lambda_function.lambda["function1"]: Creating...
module.lambda.aws_iam_role_policy_attachment.dynamodb_policy_attachment: Creation complete after 0s [id=iam_for_lambda-20240516232741245600000001]
module.api_gateway.aws_cloudwatch_log_group.api_gw: Creation complete after 1s [id=/aws/api_gw/api-gw-conf]
module.api_gateway.aws_apigatewayv2_stage.lambda: Creating...
module.api_gateway.aws_apigatewayv2_stage.lambda: Creation complete after 2s [id=$default]
module.dynamodb.aws_dynamodb_table.dynamodb-table["table1"]: Creation complete after 8s [id=userTable]
module.lambda.aws_lambda_function.lambda["function1"]: Still creating... [10s elapsed]
module.lambda.aws_lambda_function.lambda["function1"]: Creation complete after 14s [id=test-function-1]
module.lambda.aws_lambda_alias.lambda_alias["function1"]: Creating...
module.api_gateway.aws_lambda_permission.apigateway_permission["my_gw"]: Creating...
module.api_gateway.aws_apigatewayv2_authorizer.lambda_authorizer["my_gw"]: Creating...
module.api_gateway.aws_apigatewayv2_integration.lambda_integration["my_gw"]: Creating...
module.lambda.aws_lambda_alias.lambda_alias["function1"]: Creation complete after 1s [id=arn:aws:lambda:us-east-1:795062932265:function:test-function-1:dev]
module.api_gateway.aws_apigatewayv2_integration.lambda_integration["my_gw"]: Creation complete after 1s [id=ccotrn7]
module.api_gateway.aws_apigatewayv2_route.route["my_gw"]: Creating...
module.api_gateway.aws_apigatewayv2_authorizer.lambda_authorizer["my_gw"]: Creation complete after 1s [id=hyvvvm]
module.api_gateway.aws_lambda_permission.apigateway_permission["my_gw"]: Creation complete after 1s [id=AllowExecutionFromAPIGateway]
module.api_gateway.aws_apigatewayv2_route.route["my_gw"]: Creation complete after 0s [id=wi6rrhj]

Apply complete! Resources: 14 added, 0 changed, 0 destroyed.

Outputs:

Dynamodb_arn = {
  "table1" = {
    "dynamodb_arn" = "arn:aws:dynamodb:us-east-1:795062932265:table/userTable"
  }
}
api_gateway_url = "https://j6qj62s6o3.execute-api.us-east-1.amazonaws.com"
lambda_arn = {
  "function1" = {
    "invoke_arn" = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:795062932265:function:test-function-1/invocations"
    "lambda_arn" = "arn:aws:lambda:us-east-1:795062932265:function:test-function-1"
    "lambda_name" = "test-function-1"
  }
}
```

# Test endpoints

```bash
 curl -X POST  https://j6qj62s6o3.execute-api.us-east-1.amazonaws.com/register -H "Content-Type: application/json" -d '{"username":"ujstor", "password":"password123"}'
Succsessfully registered user
```

```bash
 curl -X POST  https://j6qj62s6o3.execute-api.us-east-1.amazonaws.com/login -H "Content-Type: application/json" -d '{"username":"ujstor", "password":"password123"}'
Succsessfuly logged in
```
