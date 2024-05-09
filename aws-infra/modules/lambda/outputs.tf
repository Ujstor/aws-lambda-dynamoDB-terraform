output "lambda_arn" {
  description = "Lambda ARN"
  value       = aws_lambda_function.lambda.arn
}

output "lambda_invoke_arn" {
  description = "Lambda Invoke ARN"
  value       = aws_lambda_function.lambda.invoke_arn
}

output "lambda_function_name" {
  description = "Lambda Function Name"
  value       = aws_lambda_function.lambda.function_name
}
