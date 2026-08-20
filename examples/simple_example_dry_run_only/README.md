# Simple Example with a Dry-run-only Perimeter

This example illustrates how to use the `vpc-service-controls` module to stage a regular
service perimeter in **dry-run mode only** -- every enforced input is left at its default,
and configuration is supplied exclusively through the `_dry_run` inputs.

This is the supported way to stage a perimeter and observe its violations before turning
enforcement on. It is also the only example that leaves the enforced side entirely empty,
which makes it the regression test for the module emitting an empty `status {}` block
that the API does not store.

# Requirements
1. Make sure you've gone through the root [Requirement Section](../../#requirements)



<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | `string` | n/a | yes |
| policy\_name | The policy's name. | `string` | n/a | yes |
| protected\_project\_number | Project number of the project INSIDE the dry-run service perimeter. | `number` | n/a | yes |
| scopes | Folder or project on which this policy is applicable. Format: 'folders/FOLDER\_ID' or 'projects/PROJECT\_NUMBER' | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy\_id | Resource name of the AccessPolicy. |
| policy\_name | Name of the AccessPolicy. |
| protected\_project\_number | Project number of the project INSIDE the dry-run service perimeter |
| service\_perimeter\_name | Service perimeter name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
