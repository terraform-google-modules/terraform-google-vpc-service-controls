# Access Bridge Submodule

This module handles opiniated configuration and deployment of a [access_context_manager_service_perimeter](https://www.terraform.io/docs/providers/google/r/access_context_manager_service_perimeter.html) resource for bridge service perimeter types.

## Usage
```hcl
provider "google" {
  version     = "~> 2.5.0"
}

module "org_policy" {
  source      = "terraform-google-modules/vpc-service-controls/google/modules/policy"
  parent_id   = var.parent_id
  policy_name = var.policy_name
}

module "bridge_service_perimeter_1" {
  source         = "terraform-google-modules/vpc-service-controls/google/modules/bridge_service_perimeter"
  policy         = module.org_policy.policy_id
  perimeter_name = "bridge_perimeter_1"
  description    = "Some description"

  resources = [
    module.regular_service_perimeter_1.shared_resources["all"],
    module.regular_service_perimeter_2.shared_resources["all"],
  ]
}

module "regular_service_perimeter_1" {
  source         = "terraform-google-modules/vpc-service-controls/google/modules/regular_service_perimeter"
  policy         = module.org_policy.policy_id
  perimeter_name = "regular_perimeter_1"
  description    = "Some description"
  resources      = ["1111111111"]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  shared_resources = {
    all = ["1111111111"]
  }
}

module "regular_service_perimeter_2" {
  source         = "terraform-google-modules/vpc-service-controls/google/modules/regular_service_perimeter"
  policy         = module.org_policy.policy_id
  perimeter_name = "regular_perimeter_2"
  description    = "Some description"
  resources      = ["222222222222"]

  restricted_services = ["storage.googleapis.com"]

  shared_resources = {
    all = ["222222222222"]
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| description | Description of the bridge perimeter | string | `""` | no |
| perimeter\_name | Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores | string | n/a | yes |
| policy | Name of the parent policy | string | n/a | yes |
| resources | A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. | list(string) | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| resources | A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
