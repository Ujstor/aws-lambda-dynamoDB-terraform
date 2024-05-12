variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "dynamodb" {
  description = "DynamoDB variables"
  type = map(object({
    name           = string
    billing_mode   = string
    read_capacity  = number
    write_capacity = number
    hash_key       = string
    range_key      = optional(string)
    attribute = list(object({
      name = string
      type = string
    }))
    tag_name        = optional(string)
    tag_environment = optional(string)
  }))
}
