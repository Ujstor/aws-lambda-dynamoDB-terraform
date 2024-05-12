resource "null_resource" "build-go-bin-trigger" {
  count = var.source_code_data.command != null ? 1 : 0

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    working_dir = var.source_code_data.work_dir
    command     = var.source_code_data.command
    interpreter = var.source_code_data.interpreter
  }
}

data "aws_iam_policy_document" "assume_role_lambda" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role_lambda.json

  inline_policy {}
}

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "lambda_dynamodb_policy"
  description = "Allows Lambda functions to execute read and write operations in DynamoDB"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

data "archive_file" "lambda" {
  count = var.source_code_data.command != null ? 1 : 0

  type             = var.source_code_data.archive_type
  source_file      = "${var.source_code_data.work_dir}/${var.source_code_data.bin_name}"
  output_path      = "${var.source_code_data.work_dir}/${var.source_code_data.archive_bin_name}"
  output_file_mode = "0666"

  depends_on = [null_resource.build-go-bin-trigger]
}

resource "aws_lambda_function" "lambda" {
  filename      = "${var.source_code_data.work_dir}/${var.source_code_data.archive_bin_name}"
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.lambda_handler

  runtime          = var.lambda_runtime
  source_code_hash = var.source_code_data.command != null ? data.archive_file.lambda[0].output_base64sha256 : null

  ephemeral_storage {
    size = var.ephemeral_storage
  }

  depends_on = [data.archive_file.lambda]
}
