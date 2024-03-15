# Simple Example Access Level

This example illustrates how to use the `vpc-service-controls` module to configure an org policy and an access level

# Requirements
1. Make sure you've gone through the root [Requirement Section](../../#requirements)



<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | `string` | n/a | yes |
| project\_id | The ID of the project in which to provision network. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| access\_level | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
