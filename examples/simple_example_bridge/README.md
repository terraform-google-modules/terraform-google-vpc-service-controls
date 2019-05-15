# Simple Example Bridge

This example illustrates how to use the `vpc-service-controls` module to configure an org policy, an access level, 2 regular perimeters, a bridge perimeter and a BigQuery resource inside the regular perimeter.

# Requirements
1. Make sure you've gone through the root [Requirement Section](../../#requirements)
2. Select 2 projects in your organization that will part of 2 different regular service perimeters.
3. Enable the BigQuery API on both projects
4. Grant the service account the following permissions on both projects:
 - roles/bigquery.dataOwner
 - roles/bigquery.jobUser

You may use the following gcloud commands:
   `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/bigquery.jobUser`
   `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/bigquery.dataOwner`

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials\_path | Path to credentials.json key for service account deploying resources | string | n/a | yes |
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | string | n/a | yes |
| policy\_name | The policy's name. | string | n/a | yes |
| protected\_project\_ids | Project id and number of the project INSIDE the regular service perimeter. This map variable expects an "id" for the project id and "number" key for the project number. | map | n/a | yes |
| public\_project\_ids | Project id and number of the project OUTSIDE of the regular service perimeter. This variable is only necessary for running integration tests. This map variable expects an "id" for the project id and "number" key for the project number. | map | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy\_name |  |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
