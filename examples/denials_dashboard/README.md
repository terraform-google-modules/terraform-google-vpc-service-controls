# Setting up a VPC SC denials dashboard

## Overview

This directory provides a `logging` module that sets up the Cloud Logging
configuration for a VPC SC denials dashboard, with optional `dashboard` and
`alerting` modules to set up a Cloud Monitoring dashboard and alert policy
examples.

The Terraform script does the following:

*   In `modules/logging`:
    *   Creates a project-level log bucket.
    *   Creates an organization-level aggregated sink.
    *   Creates a log-based metric in your project.
*   In `modules/dashboard`:
    *   Creates a Cloud Monitoring dashboard with widgets.
*   In `modules/alerting`:
    *   Creates alert policies for enforced and dry run denials.
    *   Creates an email notification channel.

### Terminology

*   [Log bucket](https://cloud.google.com/logging/docs/routing/overview#buckets) -
    Stores your logs data.
*   [Sink](https://cloud.google.com/logging/docs/routing/overview#sinks) -
    Controls how logs are routed. A sink routes logs that match its
    [inclusion filters](https://cloud.google.com/logging/docs/routing/overview#inclusion-filters)
    and
    [exclusion filters](https://cloud.google.com/logging/docs/routing/overview#exclusions)
    to the destination associated with the sink. For our purposes, we use an
    organization-level
    [aggregated sink](https://cloud.google.com/logging/docs/export/aggregated_sinks)
    which combines and routes logs from the Google Cloud resources contained by
    an organization. Our sink’s destination is a log bucket.
*   [Log-based metric](https://cloud.google.com/logging/docs/logs-based-metrics) -
    Counts the log entries that match a given filter. You can define custom
    [labels](https://cloud.google.com/logging/docs/logs-based-metrics/labels) to
    extract values from fields in the matching log entries.

See the
[Cloud Logging routing and storage overview](https://cloud.google.com/logging/docs/routing/overview)
for a flow diagram of how logs data is routed and stored.

## Prerequisites

### GCP Project

If you don't have one already, create a new project in your GCP organization
that will contain the VPC SC logging pipeline resources. We recommend creating a
new project to easily track usage and the cost of these resources.

### Billing account

Link a billing account to your project.

### Service Usage API

Enable the Service Usage API (serviceusage.googleapis.com).

## Setup

### Assign values to variables

Modify the variables in the **terraform.tfvars** file.

Note: **org_id** and **project_id** should be modified before running the
Terraform script.

Name                            | Description                                                                                                                                                                                | Type    | Default         | Modification required
------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------- | --------------- | ---------------------
org_id                          | Organization ID of your GCP organization                                                                                                                                                   | String  | ""              | Yes
project_id                      | Project ID of the new GCP project you created that will contain the alerting, dashboard, and logging resources (excluding the organization-level aggregated sink)                          | String  | ""              | Yes
add_dashboard                   | Boolean to determine whether or not the dashboard module should be deployed. Set to true if you want to set up a Cloud Monitoring dashboard at the same time as the logging configuration. | Boolean | False           | No
add_alerting_example            | Boolean to determine whether or not the alerting module should be deployed. Set to true if you want to set up alerting at the same time as the logging configuration.                      | Boolean | False           | No
log_bucket_name                 | Name of the log bucket                                                                                                                                                                     | String  | "vpcsc_denials" | No
log_based_metric_name           | Name of the log-based metric                                                                                                                                                               | String  | "vpcsc_denials" | No
log_router_aggregated_sink_name | Name of the log router aggregated sink for the organization                                                                                                                                | String  | "vpcsc_denials" | No
email_address                   | Email address to receive notifications from alerting                                                                                                                                       | String  | ""              | Yes if add_alerting_example is set to True, otherwise No

### Initialize Terraform

Cd into the **denials_dashboard** directory and initialize Terraform:

```
terraform init -upgrade
```

## Run the Terraform script

To preview the resources that will be created:

```
terraform plan
```

To create the resources:

```
terraform apply
```

## Verify that logs and metrics are flowing

Under **Monitoring → Log-based metrics** in the Google Cloud console, you can
view the logs for your metric to verify that data is flowing. Note that VPC SC
currently emits logs only on denials, so you might need to manually trigger a
denial to see test data.

Because we are using an aggregated sink and you may have logs from multiple
projects, make sure that when viewing the Logs Explorer, the scope is set to
“Scope by storage” and your log bucket is selected.

## Cost

Since the logging resources are deployed in your organization, you are
responsible for cost and configuring billing accounts. To see the pricing for
Cloud Logging and Cloud Monitoring, visit
https://cloud.google.com/stackdriver/pricing.

By default, the Terraform script configures a log bucket that stores all VPC SC
audit logs from your entire organization. This essentially creates a copy of all
the logs which powers the metrics and dashboards. See
https://cloud.google.com/vpc-service-controls/docs/audit-logging#viewing_logs
for how to query VPC SC Audit logs to get an idea of your current volume of logs
to estimate the cost.

If you believe this will result in high costs, you can forward logs to the
storage bucket for only particular projects. See the section **Route logs from
specific projects** below.

### Setup billing alerts

If you’re concerned about this causing an unexpectedly large bill for your
organization, you can set up a billing alert. Follow the instructions at
https://cloud.google.com/billing/docs/how-to/budgets.

## Update Service Perimeter ingress rules

This section applies to you if you have restricted the Cloud Logging API in a
Service Perimeter that protects the project containing the logging resources
created in the Terraform script above.

Without these changes, you will receive errors that say the log writer cannot
write to the log bucket due to your organization policy.

1.  Get the identity of the service account used to write logs to the log
    bucket.
    *   Go to **Monitoring → Log Router** and select the “View sink details”
        option for your aggregated sink.
    *   Copy the writer identity. (It should start with “serviceAccount:”)
2.  Allow the writer identity to send ingress traffic to the perimeter
    protecting the project with the logging resources.
    *   Find your service perimeter that protects the project with the logging
        resources.
    *   Create a new ingress rule that specifies the writer identity, the “Cloud
        Logging API” service, and the TO project should be the project with the
        logging resources.

## Next steps (optional)

### Route logs from specific projects or folders

With the current setup, the aggregated sink routes logs from all child resources
of your organization that match the inclusion filter:

```
protoPayload.metadata.@type:"type.googleapis.com/google.cloud.audit.VpcServiceControlAuditMetadata"
```

However, there might be situations where you want to
[route logs only from specific Google Cloud projects or folders](https://cloud.google.com/logging/docs/export/aggregated_sinks#gcp-source-sink).
To do this, select your organization, then go to **Monitoring → Log Router** in
the navigation menu of the Google Cloud console to view your log router sinks.

Go to the edit page for your aggregated sink. Under the section **Choose logs to
include in sink**, add the following inclusion filters to restrict logs to
specific Google Cloud projects or folders:

```
protoPayload.metadata.@type:"type.googleapis.com/google.cloud.audit.VpcServiceControlAuditMetadata" AND
logName:"projects/PROJECT_ID/logs/" AND ...
```

```
protoPayload.metadata.@type:"type.googleapis.com/google.cloud.audit.VpcServiceControlAuditMetadata" AND
logName:"folders/FOLDER_ID/logs/" AND ...
```

Click **Update Sink** to save your changes. No additional permissions or actions
are needed.

### Cloud Monitoring dashboard

To set up a Cloud Monitoring dashboard, set the **add_dashboard** variable in
the **terraform.tfvars** file to true, then run `terraform apply`.

In the navigation menu of the Google Cloud console, go to **Monitoring →
Dashboards → click on your VPC SC denials dashboard**. If everything is set up
correctly, you should be able to see your denials data.

### Alerting

To set up alerting, open the **terraform.tfvars** file:

*   Set the **add_alerting_example** variable to true.
*   Set the **email_address** variable to an email address.

Then run `terraform apply`.

#### Edit alert policy

You should now have two alerting policies set up, one for enforced denials and
one for dry run denials. You can edit these policies by going to **Monitoring →
Alerting** in the navigation menu of the Google Cloud console.

#### Add alert policy widget to Cloud Monitoring dashboard

To add an alert policy widget to your Cloud Monitoring dashboard, go to your
dashboard in Cloud Monitoring, then select **Add Widget → Alert Policy**.

### Protect the project with a Service Perimeter

Service perimeters can protect the project that contains the resources created
by the Terraform script. However, if the perimeter restricts the Cloud Logging
and Cloud Monitoring services, then your Cloud Monitoring dashboard and the
Cloud Logging resources will not be accessible through the cloud console. You
will see VPC SC policy errors trying to access these pages.

The recommended approach to access the cloud console with this setup is
documented at
https://cloud.google.com/vpc-service-controls/docs/supported-products#console.
Follow the instructions there to restore access to the console.

### Terraform best practices

See the documentation at
https://cloud.google.com/docs/terraform/best-practices-for-terraform#security
for Terraform best practices, such as storing the Terraform state in the cloud.
