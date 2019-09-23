# Access Level Submodule

This module handles opiniated configuration and deployment of [access_context_manager_level](https://www.terraform.io/docs/providers/google/r/access_context_manager_access_level.html) resource.

## Usage
```hcl
provider "google" {
  version     = "~> 2.5.0"
}

module "org_policy" {
  source      = "terraform-google-modules/vpc-service-controls/google"
  parent_id   = var.parent_id
  policy_name = var.policy_name
}

module "access_level_members" {
  source         = "terraform-google-modules/vpc-service-controls/google/modules/access_level"
  policy      = module.org_policy.policy_id
  name        = "terraform_members"
  members = ["serviceAccount:<service-account-email>", "user:<user-email>"]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed\_device\_management\_levels | Condition - A list of allowed device management levels. An empty list allows all management levels. | list(string) | `<list>` | no |
| allowed\_encryption\_statuses | Condition - A list of allowed encryptions statuses. An empty list allows all statuses. | list(string) | `<list>` | no |
| combining\_function | How the conditions list should be combined to determine if a request is granted this AccessLevel. If AND is used, each Condition must be satisfied for the AccessLevel to be applied. If OR is used, at least one Condition must be satisfied for the AccessLevel to be applied. | string | `"AND"` | no |
| description | Description of the access level | string | `""` | no |
| ip\_subnetworks | Condition - A list of CIDR block IP subnetwork specification. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated \(i.e. all the host bits must be zero\) or the input is considered malformed. For example, "192.0.2.0/24" is accepted but "192.0.2.1/24" is not. Similarly, for IPv6, "2001:db8::/32" is accepted whereas "2001:db8::1/32" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed. | list(string) | `<list>` | no |
| members | Condition - An allowed list of members \(users, service accounts\). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user \(logged in/not logged in, etc.\). Formats: user:\{emailid\}, serviceAccount:\{emailid\} | list(string) | `<list>` | no |
| minimum\_version | The minimum allowed OS version. If not set, any version of this OS satisfies the constraint. Format: "major.minor.patch" such as "10.5.301", "9.2.1". | string | `""` | no |
| name | Description of the AccessLevel and its use. Does not affect behavior. | string | n/a | yes |
| negate | Whether to negate the Condition. If true, the Condition becomes a NAND over its non-empty fields, each field must be false for the Condition overall to be satisfied. | bool | `"false"` | no |
| os\_type | The operating system type of the device. | string | `""` | no |
| policy | Name of the parent policy | string | n/a | yes |
| require\_screen\_lock | Condition - Whether or not screenlock is required for the DevicePolicy to be true. | bool | `"false"` | no |
| required\_access\_levels | Condition - A list of other access levels defined in the same Policy, referenced by resource name. Referencing an AccessLevel which does not exist is an error. All access levels listed must be granted for the Condition to be true. | list(string) | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | Description of the AccessLevel and its use. Does not affect behavior. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
