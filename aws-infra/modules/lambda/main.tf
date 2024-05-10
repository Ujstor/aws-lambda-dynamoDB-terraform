resource "terraform_data" "build-go-bin" {
  count = var.source_code_data.command != null ? 1 : 0

  provisioner "local-exec" {
    working_dir = var.source_code_data.work_dir
    command     = var.source_code_data.command
    interpreter = var.source_code_data.interpreter
  }
}

data "aws_iam_policy_document" "assume_role" {
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
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  inline_policy {}
}

data "archive_file" "lambda" {
  count = var.source_code_data.command != null ? 1 : 0

  type             = var.source_code_data.archive_type
  source_file      = "${var.source_code_data.work_dir}/${var.source_code_data.bin_name}"
  output_path      = "${var.source_code_data.work_dir}/${var.source_code_data.archive_bin_name}"
  output_file_mode = "0666"

  depends_on = [terraform_data.build-go-bin]

}

resource "aws_lambda_function" "lambda" {
  filename      = "${var.source_code_data.work_dir}/${var.source_code_data.archive_bin_name}"
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.lambda_handler

  runtime = var.lambda_runtime

  ephemeral_storage {
    size = var.ephemeral_storage
  }

  depends_on = [data.archive_file.lambda]
}
