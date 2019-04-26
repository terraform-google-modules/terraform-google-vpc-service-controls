## Permissions 
Add service account to public project as a BigQuery JobUser
gcloud projects add-iam-policy-binding <public-project-id> --member=serviceAccount:<service-account-email> --role=roles/bigquery.jobUser
--role=roles/bigquery.dataOwner

##TODO Fix issues
## Issues 
Need to enable BigQuery API on both projects.
Kitchen problems:
credentials.json not passed to env vars GOOGLE_APPLICATION_CREDENTIALS and others

## Add member access
