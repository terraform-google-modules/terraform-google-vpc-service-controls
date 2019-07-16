/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "onprem_project_id" {
  description = "The ID of the Onprem GCP project that is going to be created"
}

variable "vpc_sc_project_id" {
  description = "The ID of the VPC Service Control project that is going to be created"
}

variable "credentials_path" {
  description = "Path to the service account .json file"
}

variable "organization_id" {
  description = "Organization ID, which can be found at `gcloud organizations list`"
}

variable "billing_account_id" {
  description = "Billing account ID to which the new project should be associated"
}

variable "region" {
  description = "GCP Region (like us-west1, us-central1, etc)"
  default     = "us-west1"
}

variable "vpn_shared_secret" {
  description = "Shared secret string for VPN connection"
}

variable "access_policy_name" {
  description = "Name of the access policy"
}
