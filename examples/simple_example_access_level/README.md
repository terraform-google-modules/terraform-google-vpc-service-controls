## Permissions 
Add service account to public project as a BigQuery JobUser
gcloud projects add-iam-policy-binding <public-project-id> --member=serviceAccount:<service-account-email> --role=roles/bigquery.jobUser

## Add member access
