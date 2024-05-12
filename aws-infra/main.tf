module "lambda" {
  source = "./modules/lambda"

  lambda_config = {
    "function1" = {
      work_dir          = "../lambda/"
      bin_name          = "bootstrap"
      archive_bin_name  = "function.zip"
      function_name     = "test-function-1"
      handler           = "main"
      runtime           = "provided.al2023"
      ephemeral_storage = "512"
      archive_type      = "zip"
      command           = "GOOS=linux GOARCH=amd64 go build -o bootstrap"
      interpreter       = ["/bin/bash", "-c"]
    }
    "function2" = {
      work_dir          = "../lambda/"
      bin_name          = "bootstrap"
      archive_bin_name  = "function.zip"
      function_name     = "test-function-2"
      handler           = "main"
      runtime           = "provided.al2023"
      ephemeral_storage = "512"
      archive_type      = "zip"
      command           = "GOOS=linux GOARCH=amd64 go build -o bootstrap"
      interpreter       = ["/bin/bash", "-c"]
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
