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
      tag_description      = "createuser-1"
      tag_function_version = "$LATEST"
    },

    "function2" = {
      work_dir             = "../lambda-2/"
      bin_name             = "bootstrap"
      archive_bin_name     = "function.zip"
      function_name        = "test-function-2"
      handler              = "main"
      runtime              = "provided.al2023"
      ephemeral_storage    = "512"
      archive_type         = "zip"
      command              = "GOOS=linux GOARCH=amd64 go build -o bootstrap"
      interpreter          = ["/bin/bash", "-c"]
      tag_name             = "dev"
      tag_description      = "createuser-2"
      tag_function_version = "$LATEST"
    },
  }
}

module "dynamodb" {
  source = "./modules/dynamoDB"

  dynamodb = {
    table1 = {
      name           = "userTable-1"
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
      tag_name        = "userTable-1"
      tag_environment = "dev"
    },

    table2 = {
      name           = "userTable-2"
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
      tag_name        = "userTable-2"
      tag_environment = "dev"
    },
  }
}

module "api_gateway" {
  source = "./modules/API-gateway"

  lambda_integration_route_premission = {
    lambda_gw_1 = {
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
    },

    lambda_gw_2 = {
      lambda_invoke_arn                 = module.lambda.lambda_arn["function2"].invoke_arn
      lambda_func_name                  = module.lambda.lambda_arn["function2"].lambda_name
      integration_type                  = "AWS_PROXY"
      integration_method                = "POST"
      connection_type                   = "INTERNET"
      route_key                         = "POST /{proxy+}"
      statement_id                      = "AllowExecutionFromAPIGateway"
      action                            = "lambda:InvokeFunction"
      principal                         = "apigateway.amazonaws.com"
      authorizer_type                   = "REQUEST"
      authorizer_uri                    = module.lambda.lambda_arn["function2"].invoke_arn
      indentity_sources                 = ["$request.header.Authorization"]
      authorizer_name                   = "example-authorizer"
      authorizer_payload_format_version = "1.0"
    },
  }
}
```

## Terraform output

```bash
module.lambda.null_resource.build-go-bin-trigger["function1"]: Creating...
module.lambda.null_resource.build-go-bin-trigger["function2"]: Creating...
module.lambda.null_resource.build-go-bin-trigger["function1"]: Provisioning with 'local-exec'...
module.lambda.null_resource.build-go-bin-trigger["function1"] (local-exec): Executing: ["/bin/bash" "-c" "GOOS=linux GOARCH=amd64 go build -o bootstrap"]
module.lambda.null_resource.build-go-bin-trigger["function2"]: Provisioning with 'local-exec'...
module.lambda.null_resource.build-go-bin-trigger["function2"] (local-exec): Executing: ["/bin/bash" "-c" "GOOS=linux GOARCH=amd64 go build -o bootstrap"]
module.lambda.null_resource.build-go-bin-trigger["function1"]: Creation complete after 0s [id=7526316610225522023]
module.lambda.null_resource.build-go-bin-trigger["function2"]: Creation complete after 0s [id=7955835687058149694]
module.lambda.data.archive_file.lambda["function2"]: Reading...
module.lambda.data.archive_file.lambda["function1"]: Reading...
module.lambda.aws_iam_policy.dynamodb_policy: Creating...
module.lambda.aws_iam_role.iam_for_lambda: Creating...
module.lambda.data.archive_file.lambda["function1"]: Read complete after 0s [id=047c4dd56204b4d60067d552c65707e78b97b121]
module.lambda.data.archive_file.lambda["function2"]: Read complete after 0s [id=158f707e2ea1f09705e96e7cae5d4f96f0eb40a2]
module.dynamodb.aws_dynamodb_table.dynamodb-table["table1"]: Creating...
module.dynamodb.aws_dynamodb_table.dynamodb-table["table2"]: Creating...
module.lambda.aws_iam_policy.dynamodb_policy: Creation complete after 1s [id=arn:aws:iam::795062932265:policy/lambda_dynamodb_policy]
module.lambda.aws_iam_role.iam_for_lambda: Creation complete after 1s [id=iam_for_lambda]
module.lambda.aws_iam_role_policy_attachment.dynamodb_policy_attachment: Creating...
module.lambda.aws_lambda_function.lambda["function1"]: Creating...
module.lambda.aws_lambda_function.lambda["function2"]: Creating...
module.lambda.aws_iam_role_policy_attachment.dynamodb_policy_attachment: Creation complete after 0s [id=iam_for_lambda-20240520001910169800000001]
module.dynamodb.aws_dynamodb_table.dynamodb-table["table1"]: Creation complete after 8s [id=userTable-1]
module.dynamodb.aws_dynamodb_table.dynamodb-table["table2"]: Creation complete after 8s [id=userTable-2]
module.lambda.aws_lambda_function.lambda["function1"]: Still creating... [10s elapsed]
module.lambda.aws_lambda_function.lambda["function2"]: Still creating... [10s elapsed]
module.lambda.aws_lambda_function.lambda["function1"]: Creation complete after 13s [id=test-function-1]
module.lambda.aws_lambda_function.lambda["function2"]: Still creating... [20s elapsed]
module.lambda.aws_lambda_function.lambda["function2"]: Creation complete after 23s [id=test-function-2]
module.lambda.aws_lambda_alias.lambda_alias["function1"]: Creating...
module.lambda.aws_lambda_alias.lambda_alias["function2"]: Creating...
module.api_gateway.aws_apigatewayv2_api.lambda_api["lambda_gw_1"]: Creating...
module.api_gateway.aws_apigatewayv2_api.lambda_api["lambda_gw_2"]: Creating...
module.lambda.aws_lambda_alias.lambda_alias["function2"]: Creation complete after 0s [id=arn:aws:lambda:us-east-1:795062932265:function:test-function-2:dev]
module.lambda.aws_lambda_alias.lambda_alias["function1"]: Creation complete after 0s [id=arn:aws:lambda:us-east-1:795062932265:function:test-function-1:dev]
module.api_gateway.aws_apigatewayv2_api.lambda_api["lambda_gw_2"]: Creation complete after 1s [id=hq5r8n6dwa]
module.api_gateway.aws_apigatewayv2_api.lambda_api["lambda_gw_1"]: Creation complete after 1s [id=6dgwxnb3k0]
module.api_gateway.aws_lambda_permission.apigateway_permission["lambda_gw_2"]: Creating...
module.api_gateway.aws_apigatewayv2_authorizer.lambda_authorizer["lambda_gw_1"]: Creating...
module.api_gateway.aws_cloudwatch_log_group.api_gw["lambda_gw_1"]: Creating...
module.api_gateway.aws_cloudwatch_log_group.api_gw["lambda_gw_2"]: Creating...
module.api_gateway.aws_lambda_permission.apigateway_permission["lambda_gw_1"]: Creating...
module.api_gateway.aws_apigatewayv2_authorizer.lambda_authorizer["lambda_gw_2"]: Creating...
module.api_gateway.aws_apigatewayv2_integration.lambda_integration["lambda_gw_1"]: Creating...
module.api_gateway.aws_apigatewayv2_integration.lambda_integration["lambda_gw_2"]: Creating...
module.api_gateway.aws_apigatewayv2_integration.lambda_integration["lambda_gw_1"]: Creation complete after 0s [id=iavrfe5]
module.api_gateway.aws_lambda_permission.apigateway_permission["lambda_gw_2"]: Creation complete after 0s [id=AllowExecutionFromAPIGateway]
module.api_gateway.aws_apigatewayv2_integration.lambda_integration["lambda_gw_2"]: Creation complete after 0s [id=6i6x2t1]
module.api_gateway.aws_apigatewayv2_route.route["lambda_gw_1"]: Creating...
module.api_gateway.aws_apigatewayv2_route.route["lambda_gw_2"]: Creating...
module.api_gateway.aws_lambda_permission.apigateway_permission["lambda_gw_1"]: Creation complete after 0s [id=AllowExecutionFromAPIGateway]
module.api_gateway.aws_apigatewayv2_authorizer.lambda_authorizer["lambda_gw_1"]: Creation complete after 0s [id=d91ach]
module.api_gateway.aws_apigatewayv2_authorizer.lambda_authorizer["lambda_gw_2"]: Creation complete after 0s [id=e6gndz]
module.api_gateway.aws_cloudwatch_log_group.api_gw["lambda_gw_1"]: Creation complete after 0s [id=/aws/api_gw/lambda_gw_1-api]
module.api_gateway.aws_cloudwatch_log_group.api_gw["lambda_gw_2"]: Creation complete after 0s [id=/aws/api_gw/lambda_gw_2-api]
module.api_gateway.aws_apigatewayv2_stage.lambda["lambda_gw_1"]: Creating...
module.api_gateway.aws_apigatewayv2_stage.lambda["lambda_gw_2"]: Creating...
module.api_gateway.aws_apigatewayv2_route.route["lambda_gw_1"]: Creation complete after 0s [id=14k346g]
module.api_gateway.aws_apigatewayv2_route.route["lambda_gw_2"]: Creation complete after 0s [id=qvdacas]
module.api_gateway.aws_apigatewayv2_stage.lambda["lambda_gw_1"]: Creation complete after 2s [id=$default]
module.api_gateway.aws_apigatewayv2_stage.lambda["lambda_gw_2"]: Creation complete after 2s [id=$default]

Apply complete! Resources: 25 added, 0 changed, 0 destroyed.

Outputs:

Dynamodb_arn = {
  "table1" = {
    "dynamodb_arn" = "arn:aws:dynamodb:us-east-1:795062932265:table/userTable-1"
  }
  "table2" = {
    "dynamodb_arn" = "arn:aws:dynamodb:us-east-1:795062932265:table/userTable-2"
  }
}
api_gateway_url = {
  "lambda_gw_1" = {
    "value" = "https://6dgwxnb3k0.execute-api.us-east-1.amazonaws.com"
  }
  "lambda_gw_2" = {
    "value" = "https://hq5r8n6dwa.execute-api.us-east-1.amazonaws.com"
  }
}
lambda_arn = {
  "function1" = {
    "invoke_arn" = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:795062932265:function:test-function-1/invocations"
    "lambda_arn" = "arn:aws:lambda:us-east-1:795062932265:function:test-function-1"
    "lambda_name" = "test-function-1"
  }
  "function2" = {
    "invoke_arn" = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:795062932265:function:test-function-2/invocations"
    "lambda_arn" = "arn:aws:lambda:us-east-1:795062932265:function:test-function-2"
    "lambda_name" = "test-function-2"
  }
}
```

# Test endpoints

```bash
 curl -X POST  https://6dgwxnb3k0.execute-api.us-east-1.amazonaws.com/register -H "Content-Type: application/json" -d '{"username":"ujstor", "password":"password123"}'
Succsessfully registered user
```

```bash
 curl -X POST  https://6dgwxnb3k0.execute-api.us-east-1.amazonaws.com/login -H "Content-Type: application/json" -d '{"username":"ujstor", "password":"password123"}'
Succsessfuly logged in
```

```bash
 curl -X POST  https://hq5r8n6dwa.execute-api.us-east-1.amazonaws.com/register -H "Content-Type: application/json" -d '{"username":"ujstor2", "password":"password1234"}'
Success
```

```bash
 curl -X POST  https://hq5r8n6dwa.execute-api.us-east-1.amazonaws.com/login -H "Content-Type: application/json" -d '{"username":"ujstor2", "password":"password1234"}'
Successfully logged in!
```
