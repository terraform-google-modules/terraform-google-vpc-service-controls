# Simple Example

This example illustrates how to use the `vpc-service-controls` module to configure an org policy, an access level, a regular perimeter and a BigQuery resource inside the regular perimeter.

# Requirements

1. Make sure you've gone through the root [Requirement Section](../../README.md#requirements) on any project in your organization.
2. If you need to run integration tests for this example, select a second project in your organization. The project you already configured will be referred as the protected project that will be inside of the regular service perimeter. The second project will be the public project, which will be outside of the regular service perimeter.
3. Grant the service account the following permissions on the protected project:
 - roles/bigquery.dataOwner
 - roles/bigquery.jobUser

You may use the following gcloud commands:
   `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/bigquery.jobUser`
   `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/bigquery.dataOwner`

4. Enable BigQuery API on the protected project.
5. If you want to run the integration tests for this example, repeat step #3 and #4 on the public project.



<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| members | An allowed list of members \(users, service accounts\). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user \(logged in/not logged in, etc.\). Formats: user:\{emailid\}, serviceAccount:\{emailid\} | list(string) | n/a | yes |
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | string | n/a | yes |
| policy\_name | The policy's name. | string | n/a | yes |
| protected\_project\_ids | Project id and number of the project INSIDE the regular service perimeter. This map variable expects an "id" for the project id and "number" key for the project number. | object | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dataset\_id | Unique id for the BigQuery dataset being provisioned |
| policy\_name | Name of the parent policy |
| protected\_project\_id | Project id of the project INSIDE the regular service perimeter |
| table\_id | Unique id for the BigQuery table being provisioned |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
