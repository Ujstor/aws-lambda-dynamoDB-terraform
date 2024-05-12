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
      name           = "test-table1"
      billing_mode   = "PROVISIONED"
      read_capacity  = 5
      write_capacity = 5
      hash_key       = "UserId"
      attribute = [
        {
          name = "UserId"
          type = "S"
        },
      ]
      tag_name        = "Table1"
      tag_environment = "Production"
    },

    table2 = {
      name           = "testTable2"
      billing_mode   = "PROVISIONED"
      read_capacity  = 10
      write_capacity = 10
      hash_key       = "UserId"
      range_key      = "GameTitle"
      attribute = [
        {
          name = "UserId"
          type = "S"
        },
        {
          name = "GameTitle"
          type = "S"
        },
      ]
      tag_name        = "Table2"
      tag_environment = "Development"
    }
  }
}
