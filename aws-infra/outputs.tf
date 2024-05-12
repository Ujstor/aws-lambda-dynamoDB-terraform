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

output "Dynamodb_arn" {
  description = "DynamoDB ARN"
  value       = module.dynamodb.dynamodb_arn
}
