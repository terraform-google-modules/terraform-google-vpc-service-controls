# Simple Example Access Level with Dry-run policy

This example illustrates how to use the `vpc-service-controls` module to configure an org policy and an access level.

# Requirements
1. Make sure you've gone through the root [Requirement Section](../../#requirements)



<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ip\_subnetworks | A list of CIDR block IP subnetwork specification. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated (i.e. all the host bits must be zero) or the input is considered malformed. For example, "192.0.2.0/24" is accepted but "192.0.2.1/24" is not. Similarly, for IPv6, "2001:db8::/32" is accepted whereas "2001:db8::1/32" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed. | `list(string)` | n/a | yes |
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | `string` | n/a | yes |
| policy\_name | The policy's name. | `string` | n/a | yes |
| protected\_project\_number | Project number of the project INSIDE the regular service perimeter. | `number` | n/a | yes |
| scopes | Folder or project on which this policy is applicable. Format: 'folders/FOLDER\_ID' or 'projects/PROJECT\_NUMBER' | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_levels\_dry\_run | Access Level in Dry\_run mode |
| policy\_id | Resource name of the AccessPolicy. |
| policy\_name | Name of the AccessPolicy. |
| protected\_project\_number | Project number of the project INSIDE the regular service perimeter |
| service\_perimeter\_name | Service perimeter name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
