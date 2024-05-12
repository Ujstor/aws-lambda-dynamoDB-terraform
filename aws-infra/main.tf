module "lambda" {
  source = "./modules/lambda"

  source_code_data = {
    work_dir         = "../lambda/"
    bin_name         = "bootstrap"
    archive_bin_name = "function.zip"
    archive_type     = "zip"
    command          = "GOOS=linux GOARCH=amd64 go build -o bootstrap"
    interpreter      = ["/bin/bash", "-c"]
  }

  lambda_function_name = "test-function"
  lambda_handler       = "main"
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
