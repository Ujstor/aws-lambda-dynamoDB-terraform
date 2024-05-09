## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.15.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.48.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.48.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.iam_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [archive_file.lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_archive_source_file"></a> [archive\_source\_file](#input\_archive\_source\_file) | Path to source bin | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_ephemeral_storage"></a> [ephemeral\_storage](#input\_ephemeral\_storage) | Ephemeral storage size Min 512 MB and the Max 10240 MB | `number` | `512` | no |
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | Name of the Lambda function. | `string` | n/a | yes |
| <a name="input_lambda_handler"></a> [lambda\_handler](#input\_lambda\_handler) | Lambda handler | `string` | n/a | yes |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Lambda runtime | `string` | `"provided.al2023"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | Lambda ARN |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | Lambda Function Name |
| <a name="output_lambda_invoke_arn"></a> [lambda\_invoke\_arn](#output\_lambda\_invoke\_arn) | Lambda Invoke ARN |
