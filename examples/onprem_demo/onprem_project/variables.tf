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

variable "project_id" {
  description = "The ID of the GCP project that is going to be created"
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

variable "ip_addr_cloud_vpn_router" {
  description = "IP address that is reserved for the VPC SC project's VPN router"
}

variable "vpn_shared_secret" {
  description = "Shared secret string for VPN connection"
}
