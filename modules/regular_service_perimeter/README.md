# Access Level Submodule

This module handles opiniated configuration and deployment of a [access_context_manager_service_perimeter](https://www.terraform.io/docs/providers/google/r/access_context_manager_service_perimeter.html) resource for regular service perimeter types.

# Usage 
```hcl
module "org-policy" {
  source      = "terraform-google-modules/vpc-service-controls/google/modules/policy"
  parent_id   = "${var.parent_id}"
  policy_name = "${var.policy_name}"
}

module "regular-service-perimeter-1" {
  source         = "terraform-google-modules/vpc-service-controls/google/modules/regular_service_perimeter"
  policy         = "${module.org-policy.policy_id}"
  perimeter_name = "regular_perimeter_1"
  description    = "Some description"
  resources      = ["1111111111"]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  shared_resources = {
    all = ["1111111111"]
  }
}
```

[^]: (autogen_docs_start)

[^]: (autogen_docs_end)