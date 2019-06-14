# Auto-add project to VPC Service Controls perimeter

This is a demo of adding a newly-created project to a [VPC Service Controls perimeter](https://cloud.google.com/vpc-service-controls/).  Currently, there's not a Google Cloud product-level feature that automatically adds a new project to a service perimeter; so we have to rely on automation to do this.

## Prerequisites
To complete this demo, you'll need:
- A Google Cloud [organization](https://cloud.google.com/resource-manager/docs/quickstart-organizations) mapped to a domain that you own with at least one project already created.
- A valid billing account.
- A service account with "Access Context Manager Admin" privileges.  
- Terraform v0.11.13 with provider.google v2.6.0 (the only versions I've tested; run `terraform version` to see what you've got).

## Instructions

The instructions below are intended to be build steps in a CI/CD tool of your choice.  They should be encoded in the same build pipeline, and should follow each other in rapid succession.

0. Update `terraform.tfvars` with the value of `access_policy_name`.  You can get the access policy name by running:
    - `gcloud organizations list`
    - `gcloud access-context-manager policies list --organization=<your org number>` 
1. Create a new Google Cloud project using a CI/CD tool of your choice.
2. Once the project is created, get its project number.  You can get its project number by running `gcloud projects describe <project id>` and grepping for `projectNumber`.
3. Update the `protected_projects_list` variable in the terraform.tfvars file by appending `"projects/<project number>"`.  Make sure you do not overwrite existing values in this list, because this is the list of projects protected by a service perimeter.  If you accidentally overwrite or delete projects in this list, they'll no longer be protected by a service perimeter!
4. Run `terraform apply` to update the service perimeter to include the newly-created GCP project.


When you're done with this demo, delete the service account keys and delete the service account altogether from the Cloud Console.
