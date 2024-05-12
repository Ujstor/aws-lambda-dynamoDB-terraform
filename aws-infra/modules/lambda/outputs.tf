output "lambda_arn" {
  description = "Lambda ARN-s and name"
  value = {
    for key, _ in var.lambda_config :
    key => {
      lambda_name = aws_lambda_function.lambda[key].function_name
      lambda_arn  = aws_lambda_function.lambda[key].arn
      invoke_arn  = aws_lambda_function.lambda[key].invoke_arn
    }
  }
}
