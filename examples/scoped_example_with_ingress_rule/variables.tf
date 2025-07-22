/**
 * Copyright 2024 Google LLC
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

variable "parent_id" {
  description = "The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent."
  type        = string
}

variable "policy_name" {
  description = "The policy's name."
  type        = string
}

variable "protected_project_ids" {
  description = "Project id and number of the project INSIDE the regular service perimeter. This map variable expects an \"id\" for the project id and \"number\" key for the project number."
  type        = object({ id = string, number = number })
}

variable "public_project_ids" {
  description = "Project id and number of the project OUTSIDE the regular service perimeter. This map variable expects an \"id\" for the project id and \"number\" key for the project number."
  type        = object({ id = string, number = number })
}

variable "members" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = list(string)
}

variable "regions" {
  description = "The request must originate from one of the provided countries/regions. Format: A valid ISO 3166-1 alpha-2 code."
  type        = list(string)
  default     = []
}

variable "perimeter_name" {
  description = "Perimeter name of the Access Policy.."
  type        = string
  default     = "regular_perimeter_1"
}

variable "access_level_name" {
  description = "Access level name of the Access Policy."
  type        = string
  default     = "terraform_members"
}

variable "access_level_name_dry_run" {
  description = "Access level name of the Access Policy in Dry-run mode."
  type        = string
  default     = "terraform_members_dry_run"
}

variable "read_bucket_identities" {
  description = "List of all identities should get read access on bucket"
  type        = list(string)
  default     = []
}

variable "buckets_prefix" {
  description = "Bucket Prefix"
  type        = string
  default     = "test-bucket"
}

variable "buckets_names" {
  description = "Buckets Names as list of strings"
  type        = list(string)
  default     = ["bucket1", "bucket2"]
}

variable "scopes" {
  description = "Folder or project on which this policy is applicable. Format: 'folders/FOLDER_ID' or 'projects/PROJECT_NUMBER'"
  type        = list(string)
  default     = []
}
