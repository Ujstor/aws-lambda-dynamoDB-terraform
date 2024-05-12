resource "aws_dynamodb_table" "dynamodb-table" {
  for_each = var.dynamodb

  name           = each.value.name
  billing_mode   = each.value.billing_mode
  read_capacity  = each.value.read_capacity
  write_capacity = each.value.write_capacity
  hash_key       = each.value.hash_key
  range_key      = each.value.range_key

  dynamic "attribute" {
    for_each = each.value.attribute
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  tags = {
    Name        = each.value.tag_name
    Environment = each.value.tag_environment
  }
}

