# Access Level Submodule

This module handles opiniated configuration and deployment of [access_context_manager_level](https://www.terraform.io/docs/providers/google/r/access_context_manager_access_level.html) resource.

# Usage 
```hcl
module "org-policy" {
  source      = "terraform-google-modules/vpc-service-controls/google"
  parent_id   = "${var.parent_id}"
  policy_name = "${var.policy_name}"
}

module "access-level-members" {
  source         = "terraform-google-modules/vpc-service-controls/google/modules/access_level"
  policy      = "${module.org-policy.policy_id}"
  name        = "terraform_members"
  members = ["serviceAccount:<service-account-email>", "user:<user-email>"]
}
```
[^]: (autogen_docs_start)

[^]: (autogen_docs_end)