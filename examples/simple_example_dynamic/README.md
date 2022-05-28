# Simple Example Dynamic

This example illustrates how to use the module to create two perimeters, with projects inside of them, and a bridge between the two.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| billing\_account | The billing account to use for creating projects | `string` | n/a | yes |
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | `string` | n/a | yes |
| policy\_name | The policy's name. | `string` | `"vpc-sc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy\_id | The ID of the created policy |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
