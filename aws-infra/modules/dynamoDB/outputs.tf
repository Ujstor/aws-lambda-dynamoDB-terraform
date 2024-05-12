output "dynamodb_arn" {
  description = "DynamoDB ARN"
  value = {
    for key, _ in var.dynamodb :
    key => {
      dynamodb_arn = aws_dynamodb_table.dynamodb-table[key].arn
    }
  }
}
