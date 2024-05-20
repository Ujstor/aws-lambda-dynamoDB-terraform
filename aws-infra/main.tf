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
