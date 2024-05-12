## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.15.1 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | 2.4.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.48.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.4.2 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.48.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.dynamodb_policy](https://registry.terraform.io/providers/hashicorp/aws/5.48.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.iam_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/5.48.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.dynamodb_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/5.48.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/5.48.0/docs/resources/lambda_function) | resource |
| [null_resource.build-go-bin-trigger](https://registry.terraform.io/providers/hashicorp/null/3.2.2/docs/resources/resource) | resource |
| [archive_file.lambda](https://registry.terraform.io/providers/hashicorp/archive/2.4.2/docs/data-sources/file) | data source |
| [aws_iam_policy_document.assume_role_lambda](https://registry.terraform.io/providers/hashicorp/aws/5.48.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_ephemeral_storage"></a> [ephemeral\_storage](#input\_ephemeral\_storage) | Ephemeral storage size Min 512 MB and the Max 10240 MB | `number` | `512` | no |
| <a name="input_lambda_handler"></a> [lambda\_handler](#input\_lambda\_handler) | Lambda handler | `string` | n/a | yes |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Lambda runtime | `string` | `"provided.al2023"` | no |
| <a name="input_lambda_config"></a> [source\_code\_data](#input\_source\_code\_data) | Lambda function directory source code, bin and archive bin name, comad for compiling bin | <pre>map(object({<br>    work_dir         = string<br>    bin_name         = string<br>    archive_bin_name = string<br>    function_name    = string<br>    archive_type     = optional(string)<br>    command          = optional(string)<br>    interpreter      = optional(list(string))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | Lambda ARN-s and name |
