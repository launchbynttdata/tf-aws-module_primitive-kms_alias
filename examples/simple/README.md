# Simple Example

This example provides a basic test case for the `tf-aws-module_primitive-vpc_security_group_ingress_rule` module, used primarily for integration testing.

## Features

- Single SSH ingress rule (port 22)
- IPv4 CIDR source
- Basic configuration

## Usage

```bash
terraform init
terraform plan -var-file=test.tfvars
terraform apply -var-file=test.tfvars
terraform destroy -var-file=test.tfvars
```

## Resources Created

- 1 VPC
- 1 Security Group
- 1 Security Group Ingress Rule

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.100 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |
| <a name="module_kms_key"></a> [kms\_key](#module\_kms\_key) | terraform.registry.launch.nttdata.com/module_primitive/kms_key/aws | ~> 0.1 |
| <a name="module_kms_alias"></a> [kms\_alias](#module\_kms\_alias) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object({<br/>    name       = string<br/>    max_length = optional(number, 60)<br/>  }))</pre> | <pre>{<br/>  "key": {<br/>    "max_length": 64,<br/>    "name": "key"<br/>  },<br/>  "key_alias": {<br/>    "max_length": 64,<br/>    "name": "alias"<br/>  }<br/>}</pre> | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | The logical product family for the resource names. | `string` | `"key"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | The logical product service for the resource names. | `string` | `"alias"` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region for the resource names. | `string` | `"us-west-2"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | The class environment for the resource names. | `string` | `"dev"` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | The instance environment for the resource names. | `string` | `"000"` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | The instance resource for the resource names. | `string` | `"000"` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Whether to enable key rotation for the KMS key. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_alias_arn"></a> [kms\_alias\_arn](#output\_kms\_alias\_arn) | The Amazon Resource Name (ARN) of the alias. |
| <a name="output_target_key_arn"></a> [target\_key\_arn](#output\_target\_key\_arn) | The ARN of the target KMS Key. |
<!-- END_TF_DOCS -->
