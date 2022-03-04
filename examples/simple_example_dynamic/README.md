# Simple Example Dynamic

This example illustrates how to use the module to create two perimeters, with projects inside of them, and a bridge between the two.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | `string` | n/a | yes |
| policy\_name | The policy's name. | `string` | n/a | yes |
| protected\_project\_ids | Project id and number of the project INSIDE the regular service perimeter. This map variable expects an "id" for the project id and "number" key for the project number. | `object({ id = string, number = number })` | n/a | yes |
| public\_project\_ids | Project id and number of the project OUTSIDE of the regular service perimeter. This variable is only necessary for running integration tests. This map variable expects an "id" for the project id and "number" key for the project number. | `object({ id = string, number = number })` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy\_name | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
