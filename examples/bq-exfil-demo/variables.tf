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

variable "org_id" {
  description = "Organization ID. e.g. 1234567898765"
  type        = "string"
}

variable "billing_account" {
  description = "Billing Account id. e.g. AAAAAA-BBBBBB-CCCCCC"
  type        = "string"
}

variable "folder_id" {
  description = "Folder ID within the Organization: e.g. 1234567898765"
  type        = "string"
  default     = ""
}
variable "members" {
  description = "List of members in the standard GCP form: user:{email}, serviceAccount:{email}, group:{email}"
  type        = "list"
  default     = []
}

variable "terraform_service_account" {
  type        = "string"
  description = "The Terraform service account email that should still be allowed in the perimeter to create buckets, datasets, etc."
}

variable "perimeter_name" {
  type        = "string"
  description = "Name of the VPC SC perimeter"
  default     = "protect_the_daters"
}

variable "region" {
  description = "Region where the bastion host will run"
  type        = "string"
  default     = "us-west1"
}

variable "zone" {
  description = "Zone where the bastion host will run"
  type        = "string"
  default     = "us-west1-a"
}

variable "enabled_apis" {
  description = "List of APIs to enable on the created projects"
  type        = "list"
  default = [
    "iap.googleapis.com",
    "oslogin.googleapis.com",
    "compute.googleapis.com",
    "bigquery-json.googleapis.com",
    "storage-api.googleapis.com",
  ]
}
