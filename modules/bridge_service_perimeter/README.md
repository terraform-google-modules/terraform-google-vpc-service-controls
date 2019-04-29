# Access Bridge Submodule

This module handles opiniated configuration and deployment of a [access_context_manager_service_perimeter](https://www.terraform.io/docs/providers/google/r/access_context_manager_service_perimeter.html) resource for bridge service perimeter types.

## Usage 
```hcl
module "org-policy" {
  source      = "../../modules/policy"
  parent_id   = "${var.parent_id}"
  policy_name = "${var.policy_name}"
}

module "bridge-service-perimeter-1" {
  source         = "../../modules/bridge_service_perimeter"
  policy         = "${module.org-policy.policy_id}"
  perimeter_name = "bridge_perimeter_1"
  description    = "Some description"

  resources = [
    "${module.regular-service-perimeter-1.shared_resources["all"]}",
    "${module.regular-service-perimeter-2.shared_resources["all"]}",
  ]
}

module "regular-service-perimeter-1" {
  source         = "../../modules/regular_service_perimeter"
  policy         = "${module.org-policy.policy_id}"
  perimeter_name = "regular_perimeter_1"
  description    = "Some description"
  resources      = ["1111111111"]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  shared_resources = {
    all = ["1111111111"]
  }
}

module "regular-service-perimeter-2" {
  source         = "terraform-google-modules/vpc-service-controls/google/modules/bridge_service_perimeter"
  policy         = "${module.org-policy.policy_id}"
  perimeter_name = "regular_perimeter_2"
  description    = "Some description"
  resources      = ["222222222222"]

  restricted_services = ["storage.googleapis.com"]

  shared_resources = {
    all = ["222222222222"]
  }
}
```

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| description | Description of the bridge perimeter | string | n/a | yes |
| perimeter\_name | Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores | string | n/a | yes |
| policy | Name of the parent policy | string | n/a | yes |
| resources | A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| resources | A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. |

[^]: (autogen_docs_end)
