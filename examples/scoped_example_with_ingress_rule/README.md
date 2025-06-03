# Simple Example with Ingress Rule

This example illustrates how to use the `vpc-service-controls` module to configure a scoped org policy, a regular perimeter with storage buckets that can be access in it from outside read only via ingress rule.

# Requirements

1. Make sure you've gone through the root [Requirement Section](../../README.md#requirements) on any project in your organization.
2. If you need to run integration tests for this example, select a second project in your organization. The project you already configured will be referred as the protected project that will be inside of the regular service perimeter. The second project will be the public project, which will be outside of the regular service perimeter.
3. Grant the service account the following permissions on the protected project:
 - roles/storage.Admin

You may use the following gcloud commands:
   `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/storage.Admin`

1. Enable Storage API on the protected project.
2. If you want to run the integration tests for this example, repeat step #3 and #4 on the public project.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_level\_name | Access level name of the Access Policy. | `string` | `"terraform_members"` | no |
| buckets\_names | Buckets Names as list of strings | `list(string)` | <pre>[<br>  "bucket1",<br>  "bucket2"<br>]</pre> | no |
| buckets\_prefix | Bucket Prefix | `string` | `"test-bucket"` | no |
| members | An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid} | `list(string)` | n/a | yes |
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | `string` | n/a | yes |
| perimeter\_name | Perimeter name of the Access Policy.. | `string` | `"regular_perimeter_1"` | no |
| policy\_name | The policy's name. | `string` | n/a | yes |
| protected\_project\_ids | Project id and number of the project INSIDE the regular service perimeter. This map variable expects an "id" for the project id and "number" key for the project number. | `object({ id = string, number = number })` | n/a | yes |
| public\_project\_ids | Project id and number of the project OUTSIDE the regular service perimeter. This map variable expects an "id" for the project id and "number" key for the project number. | `object({ id = string, number = number })` | n/a | yes |
| read\_bucket\_identities | List of all identities should get read access on bucket | `list(string)` | `[]` | no |
| regions | The request must originate from one of the provided countries/regions. Format: A valid ISO 3166-1 alpha-2 code. | `list(string)` | `[]` | no |
| scopes | Folder or project on which this policy is applicable. Format: 'folders/FOLDER\_ID' or 'projects/PROJECT\_NUMBER' | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy\_id | Resource name of the AccessPolicy. |
| policy\_name | Name of the parent policy |
| protected\_project\_id | Project id of the project INSIDE the regular service perimeter |
| service\_perimeter\_name | Service perimeter name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
