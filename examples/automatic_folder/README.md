# Automatic folder securing Example

This example illustrates how to use the `vpc-service-controls` module to configure an org policy, an access level and a regular perimeter with projects inside a folder.

## Set up

**Please note, that whole example folder is uploaded as a Cloud Function. Do not store credentials in it.**

1. Make sure you've gone through the root [Requirement Section](../../README.md#requirements) on any project in your organization.

2. Choose or create a project for hosting the VPC Service Controls manager.

3. Activate the required APIs:
    - cloudfunctions.googleapis.com
    - accesscontextmanager.googleapis.com

3. Create a Google Cloud Storage bucket to hold Terraform state.

    ```sh
    gsutil mb -p YOUR_PROJECT gs://YOUR_BUCKET_NAME
    ```

4. Copy `backend.tf.sample` to `backend.tf` and change the bucket to match your own on line 5.

    ```sh
    cp backend.tf.sample backend.tf
    ```

3. Create a local `terraform.tfvars` file with required inputs, like this:

    ```tf
    project_id          = "YOUR_PROJECT"
    parent_id           = "ORG_ID"
    folder_id           = "FOLDER_ID"
    policy_name         = "automatic_folder"
    members             = ["user:YOUR_NAME@google.com"]
    region              = "us-east1"
    restricted_services = ["storage.googleapis.com"]
    ```

4. Run `terraform apply` to create the perimeter and watching function.

5. Grant the Cloud Function's SA access to your organization and management project. It needs these roles:

    - Access Context Manager Admin (`roles/accesscontextmanager.policyAdmin`)
    - Editor on the watched project (`roles/editor`)
    - Logs Configuration Writer on the watched folder (`roles/logging.configWriter`)

    ```bash
    SA_ID=$(terraform output function_service_account)
    ORG_ID=$(terraform output organization_id)
    PROJECT_ID=$(terraform output project_id)
    FOLDER_ID=$(terraform output folder_id)
    gcloud organizations add-iam-policy-binding \
        "${ORG_ID}" \
        --member="serviceAccount:${SA_ID}" \
        --role="roles/accesscontextmanager.policyAdmin"
    gcloud projects add-iam-policy-binding \
        "${PROJECT_ID}" \
        --member="serviceAccount:${SA_ID}" \
        --role="roles/editor"
    gcloud resource-manager folders add-iam-policy-binding \
        "${FOLDER_ID}" \
        --member="serviceAccount:${SA_ID}" \
        --role="roles/logging.configWriter"
    ```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| folder\_id | Folder ID to watch for projects. | string | n/a | yes |
| members | An allowed list of members \(users, service accounts\). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user \(logged in/not logged in, etc.\). Formats: user:\{emailid\}, serviceAccount:\{emailid\} | list(string) | n/a | yes |
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent \(ID\). | string | n/a | yes |
| perimeter\_name | Name of perimeter. | string | `"regular_perimeter"` | no |
| policy\_name | The policy's name. | string | n/a | yes |
| project\_id | The ID of the project to which resources will be applied. | string | n/a | yes |
| region | The region in which resources will be applied. | string | n/a | yes |
| restricted\_services | List of services to restrict. | list(string) | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy\_name | Name of the parent policy |
| protected\_project\_ids | Project ids of the projects INSIDE the regular service perimeter |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
