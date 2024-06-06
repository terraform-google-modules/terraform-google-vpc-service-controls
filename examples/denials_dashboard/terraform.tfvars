#-------------------------------------------------------------------------------
# The variables in this top section should be modified before running the
# Terraform script.
#-------------------------------------------------------------------------------

# Organization ID of the GCP organization
org_id = ""

# Project ID of the GCP project that these resources should belong to
project_id = ""

#-------------------------------------------------------------------------------
# These variables can be modified for your needs.
#-------------------------------------------------------------------------------

# Boolean to determine whether or not the dashboard module should be deployed
add_dashboard = false

# Boolean to determine whether or not the alerting module should be deployed
add_alerting_example = false

# Name of the log bucket
log_bucket_name = "vpcsc_denials"

# Name of the log-based metric
log_based_metric_name = "vpcsc_denials"

# Name of the log router aggregated sink for the organization
log_router_aggregated_sink_name = "vpcsc_denials"

# Email address to receive notifications from alerting
email_address = ""
