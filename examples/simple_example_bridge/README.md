# Simple Example Bridge

This example illustrates how to use the `vpc-service-controls` module to configure an org policy, an access level, 2 regular perimeters, a bridge perimeter and a BigQuery resource inside the regular perimeter.

# Requirements
1. Make sure you've gone through the root [Requirement Section](../../#requirements)
2. Select 2 projects in your organization that will part of 2 different regular service perimeters.
3. Enable the BigQuery API on both projects

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | string | n/a | yes |
| policy\_name | The policy's name. | string | n/a | yes |
| protected\_project\_ids | Project id and number of the project INSIDE the regular service perimeter | map | `<map>` | no |
| public\_project\_ids | Project id and number of the project OUTSIDE of the regular service perimeter. This variable is only necessary for running integration tests. | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| parent\_id |  |
| policy\_name |  |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
