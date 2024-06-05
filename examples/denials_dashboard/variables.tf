# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "add_dashboard" {
  type        = bool
  description = "Boolean to determine whether or not the dashboard module should be deployed"
  default     = true
}

variable "add_alerting_example" {
  type        = bool
  description = "Boolean to determine whether or not the alerting module should be deployed"
  default     = false
}

variable "org_id" {
  type        = string
  description = "Organization ID of the GCP organization"
}

variable "project_id" {
  type        = string
  description = "Project ID of the GCP project that these resources should belong to"
}

variable "log_bucket_name" {
  type        = string
  description = "Name of the log bucket"
  default     = "vpcsc_denials"
}

variable "log_based_metric_name" {
  type        = string
  description = "Name of the log-based metric"
  default     = "vpcsc_denials"
}

variable "log_router_aggregated_sink_name" {
  type        = string
  description = "Name of the log router aggregated sink for the organization"
  default     = "vpcsc_denials"
}

variable "email_address" {
  type        = string
  description = "Email address to receive notifications from alerting"
}
