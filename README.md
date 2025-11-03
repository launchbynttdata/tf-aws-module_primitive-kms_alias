# tf-aws-module_primitive-kms_alias

Primitive Terraform module that creates a single `aws_kms_alias` resource. The repository also ships with a runnable example and automated validation so that teams can compose this primitive into larger modules or stacks.

## Repository Layout

- `main.tf`, `variables.tf`, `outputs.tf` – core module surface wrapping the `aws_kms_alias` resource.
- `examples/simple` – minimal example that wires the module to an existing key via `test.tfvars`.
- `tests/` – Terratest-based post-deploy functional tests plus shared helpers under `tests/testimpl`.
- `Makefile` – entry point for common developer workflows (dependency bootstrap, lint, test, etc.).

## Prerequisites

- Terraform `~> 1.5` and the AWS provider `~> 5.100` (validated by `versions.tf`).
- Go `1.24` for the Terratest suite (`go.mod` enforces the toolchain).
- `mise` or `asdf` to install required CLIs from `.tool-versions`, or have compatible versions of `terraform`, `tflint`, `regula`, `conftest`, and `golangci-lint` available on your `PATH`.
- AWS credentials with permission to call `sts:GetCallerIdentity`; tests assume the default AWS CLI profile unless you override `AWS_PROFILE`/`AWS_REGION`.

## Initial Setup

1. Install dependencies with `make configure-dependencies` (uses either `mise` or `asdf`).
2. Run `make configure-git-hooks` to install the repo’s pre-commit hooks (requires `python3`).
3. Export any cloud credentials needed for Terratest (for AWS this can simply be your standard CLI profile).

## Development Workflow

- `make lint` – formats Terraform (recursive `terraform fmt`), runs `tflint`, validates both modules and examples, and executes Go linting via `golangci-lint`.
- `make test` – clones any custom policy rules, regenerates example provider files, creates Terraform plans for each example, evaluates policies with `conftest` and `regula`, and runs the Go post-deploy tests.
- `make tfmodule/plan` – generate Terraform plans for the examples without running policy or Go tests.
- `make go/test` or `make go/readonly_test` – execute all or readonly Terratest suites directly.
- `go mod tidy` – run after changing Go dependencies; commit resulting `go.sum` updates.
- `make check` - run the full suite of validation and tests.
- `pre-commit run` - run the precommit hooks before you commit your changes to avoid surprises and delays when pushing your code.

Prior to opening a pull request, run `make lint test` and ensure examples apply cleanly against a sandbox account. Update or add Terratest coverage when changing module behavior.

## Working With Examples

The `examples/simple` configuration expects a target KMS key. Supply one by editing `test.tfvars` or by passing `-var target_key_id=...` when planning. To verify manually:

```shell
cd examples/simple
terraform init
terraform plan -var-file=test.tfvars
```

The repository keeps example state files only for reference—avoid committing changes to `terraform.tfstate*` when updating examples.

## Contributing Tips

- Keep the module primitive: expose only arguments and outputs that map directly to the underlying `aws_kms_alias` resource.
- Document behavior changes in this README and ensure `variables.tf`/`outputs.tf` descriptions stay in sync.
- Use `make secrets-baseline` if you add or rotate secrets detection configuration.
- Follow conventional commit hygiene and include test evidence in pull request descriptions when possible.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.100 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the resource. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Creates a unique name beginning with the specified prefix. Conflicts with 'name'. | `string` | `null` | no |
| <a name="input_target_key_id"></a> [target\_key\_id](#input\_target\_key\_id) | T(Required) Identifier for the key for which the alias is for, can be either an ARN or key\_id. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_alias_arn"></a> [kms\_alias\_arn](#output\_kms\_alias\_arn) | The ARN of the KMS Alias. |
| <a name="output_target_key_arn"></a> [target\_key\_arn](#output\_target\_key\_arn) | The ARN of the target KMS Key. |
| <a name="output_name"></a> [name](#output\_name) | The name of the KMS Alias. |
<!-- END_TF_DOCS -->
