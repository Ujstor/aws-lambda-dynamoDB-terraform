variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "source_code_data" {
  description = "Lambda function directory source code, bin and archive bin name, comad for compiling bin"
  type = object({
    work_dir         = string
    bin_name         = string
    archive_bin_name = string
    archive_type     = optional(string)
    command          = optional(string)
    interpreter      = optional(list(string))
  })
}


variable "lambda_function_name" {
  description = "Name of the Lambda function."
  type        = string
}

variable "lambda_handler" {
  description = "Lambda handler"
  type        = string
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "provided.al2023"

}

variable "ephemeral_storage" {
  description = "Ephemeral storage size Min 512 MB and the Max 10240 MB"
  type        = number
  default     = 512

}

