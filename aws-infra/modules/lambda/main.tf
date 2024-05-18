resource "null_resource" "build-go-bin-trigger" {
  for_each = var.lambda_config

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    working_dir = each.value.work_dir
    command     = each.value.command
    interpreter = each.value.interpreter
  }
}

data "archive_file" "lambda" {
  for_each = var.lambda_config

  type             = each.value.archive_type
  source_file      = "${each.value.work_dir}/${each.value.bin_name}"
  output_path      = "${each.value.work_dir}/${each.value.archive_bin_name}"
  output_file_mode = "0666"

  depends_on = [null_resource.build-go-bin-trigger]
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

resource "aws_lambda_function" "lambda" {
  for_each = var.lambda_config

  filename         = "${each.value.work_dir}/${each.value.archive_bin_name}"
  function_name    = each.value.function_name
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = each.value.handler
  runtime          = each.value.runtime
  source_code_hash = data.archive_file.lambda[each.key].output_base64sha256

  ephemeral_storage {
    size = each.value.ephemeral_storage
  }

  depends_on = [data.archive_file.lambda]
}

resource "aws_lambda_alias" "lambda_alias" {
  for_each = {
    for name, config in var.lambda_config : name => config if config.tag_name != null
  }

  name             = each.value.tag_name
  description      = each.value.tag_description
  function_name    = aws_lambda_function.lambda[each.key].arn
  function_version = each.value.tag_function_version

  depends_on = [aws_lambda_function.lambda]
}

