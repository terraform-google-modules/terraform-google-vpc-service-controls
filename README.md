# terraform-google-vpc-service-controls

This module handles opinionated VPC Service Controls and Access Context Manager configuration and deployments.

## Compatibility
This module is meant for use with Terraform 0.13. If you haven't
[upgraded](https://www.terraform.io/upgrade-guides/0-13.html) and need a Terraform
0.12.x-compatible version of this module, the last released version
intended for Terraform 0.12.x is [v2.1.0](https://registry.terraform.io/modules/terraform-google-modules/-vpc-service-controls/google/v2.1.0).

## Usage
The root module only handles the configuration of the [access_context_manager_policy resource](https://www.terraform.io/docs/providers/google/r/access_context_manager_access_policy.html). For examples on how to use the root module with along with other submodules to configure all of VPC Service Controls and Access Context Manager resources, see the [examples](./examples/) folder and the [modules](./modules/) folder

```hcl
provider "google" {
  version = "~> 3.19.0"
}

module "org_policy" {
  source      = "terraform-google-modules/vpc-service-controls/google"
  parent_id   = var.parent_id
  policy_name = var.policy_name
}

module "access_level_members" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  policy  = module.org_policy.policy_id
  name    = "terraform_members"
  members = var.members
}

module "regular_service_perimeter_1" {
  source              = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  policy              = module.org_policy.policy_id
  perimeter_name      = "regular_perimeter_1"
  description         = "Perimeter shielding projects"
  resources           = ["1111111"]
  access_levels       = [module.access_level_members.name]
  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]
  shared_resources    = {
    all = ["11111111"]
  }
}
```

Then perform the following commands on the root folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

### Known limitations

The [Access Context Manager API](https://cloud.google.com/access-context-manager/docs/) guarantees that resources will be created, but there may be a delay between a successful response and the change taking effect. For example, ["after you create a service perimeter, it may take up to 30 minutes for the changes to propagate and take effect"](https://cloud.google.com/vpc-service-controls/docs/create-service-perimeters).
Because of these limitations in the API, you may first get an error when running `terraform apply` for the first time. However, for the [examples](./examples/) you should be able to succesfully deploy all resources by running `terraform apply` a second about 15 seconds after running it for the first time.
You can add a delay using terraform's [`null_resource`](https://www.terraform.io/docs/providers/null/resource.html) - check [example](./examples/simple_example/main.tf) in the tests.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | `string` | n/a | yes |
| policy\_name | The policy's name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy\_id | Resource name of the AccessPolicy. |
| policy\_name | The policy's name. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

Before this module can be used on a project, you must ensure that the following pre-requisites are fulfilled:

1. Terraform is [installed](#software-dependencies) on the machine where Terraform is executed.
2. The Service Account you execute the module with has the right [permissions](#configure-a-service-account).
3. The necessary APIs are [active](#enable-apis) on the project.

The [project factory](https://github.com/terraform-google-modules/terraform-google-project-factory) can be used to provision projects with the correct APIs active.

### Software Dependencies
### Terraform
- [Terraform](https://www.terraform.io/downloads.html) >= 0.13.0
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) >= v3.19.0

### Configure a Service Account

#### Organization level permissions
In order to create a policy, you need to grant your service account the Access Context Manager Admin role at the organization level:
- roles/accesscontextmanager.policyAdmin

You may use the following command:
`gcloud organizations add-iam-policy-binding ORGANIZATION_ID \
  --member="serviceAccount:example@project_id.iam.gserviceaccount.com" \
  --role="roles/accesscontextmanager.policyAdmin"`

### Configure user permission
In order to view VPC Service Controls and Access Context Manger using the Google Cloud Platform Console, your user accounts will need to be granted the Resource Manager Organization Viewer:
- roles/resourcemanager.organizationViewer

You may use the following command:
`gcloud projects add-iam-policy-binding <my project id> \
  --member="user:example@domain.com" \
  --role="roles/resourcemanager.organizationViewer"`

For more information see the [Access Context Manager ACL Page](https://cloud.google.com/access-context-manager/docs/access-control)


### Enable APIs
To use this module you must enable Access Context Manager API (accesscontextmanager.googleapis.com) on project.

In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Storage JSON API - storage-api.googleapis.com
- Big Query API - bigquery.googleapis.com

## Install

Be sure you have the correct Terraform version (0.12.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/
