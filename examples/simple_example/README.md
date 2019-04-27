# Simple Example

This example illustrates how to use the `vpc-service-controls` module to configure an org policy, an access level, a regular regular perimeter and a BigQuery resource inside the regular perimeter.

# Requirements

1. Make sure you've gone through the root [Requirement Section](../../#requirements) on any project in your organization.
2. Select a second project in your organization. The project you already configured project will be referred as the protected project that will be inside of the regualr service perimeter. The second project will be the public project, which will outside the regular service perimeter.
3. Enable BigQuery API on the public project.
4. Grant the service account the following permissions on the protected and public projects:
- roles/bigquery.dataOwner
- roles/bigquery.jobUser

You may use the following gcloud:
`gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/bigquery.jobUser`
`gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/bigquery.dataOwner`




[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| members | An allowed list of members (users, groups, service accounts). The signed-in user originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, not present in any groups, etc.). Formats: user:{emailid}, group:{emailid}, serviceAccount:{emailid} | list | `<list>` | no |
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | string | n/a | yes |
| policy\_name | The policy's name. | string | n/a | yes |
| protected\_project\_ids | Project id and number of the project INSIDE the regular service perimeter | map | `<map>` | no |
| public\_project\_ids | Project is and number of the project OUTSIDE of the regular service perimeter | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| dataset\_id |  |
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. |
| policy\_name | Name of the parent policy |
| protected\_project\_id | Project id of the project INSIDE the regular service perimeter |
| public\_project\_id | Project id of the project OUTSIDE of the regular service perimeter |
| table\_id |  |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
