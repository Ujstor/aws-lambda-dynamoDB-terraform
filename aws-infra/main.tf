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

output "lambda_arn" {
  description = "Lambda ARN"
  value       = module.lambda.lambda_arn
}

output "lambda_invoke_arn" {
  description = "Lambda Invoke ARN"
  value       = module.lambda.lambda_invoke_arn
}

output "lambda_function_name" {
  description = "Lambda Function Name"
  value       = module.lambda.lambda_function_name
}
