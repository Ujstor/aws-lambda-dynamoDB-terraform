variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "lambda_config" {
  description = "Lambda function configuration"
  type = map(object({
    work_dir             = string
    bin_name             = string
    archive_bin_name     = string
    function_name        = string
    handler              = string
    runtime              = string
    ephemeral_storage    = number
    archive_type         = string
    command              = string
    interpreter          = list(string)
    tag_name             = optional(string)
    tag_description      = optional(string)
    tag_function_version = optional(string)
  }))
}
