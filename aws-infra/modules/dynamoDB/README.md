## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.15.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.48.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.48.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.dynamodb-table](https://registry.terraform.io/providers/hashicorp/aws/5.48.0/docs/resources/dynamodb_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_dynamodb"></a> [dynamodb](#input\_dynamodb) | DynamoDB variables | <pre>map(object({<br>    name           = string<br>    billing_mode   = string<br>    read_capacity  = number<br>    write_capacity = number<br>    hash_key       = string<br>    range_key      = optional(string)<br>    attribute = list(object({<br>      name = string<br>      type = string<br>    }))<br>    tag_name        = optional(string)<br>    tag_environment = optional(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_arn"></a> [dynamodb\_arn](#output\_dynamodb\_arn) | DynamoDB ARN |
