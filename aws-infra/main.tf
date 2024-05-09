module "lambda" {
  source = "./modules/lambda"

  archive_source_file  = "./"
  lambda_function_name = "test-function"
  lambda_handler       = "main.handler"
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
