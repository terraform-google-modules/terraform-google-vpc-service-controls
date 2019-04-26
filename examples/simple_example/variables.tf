/**
 * Copyright 2018 Google LLC
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
}

variable "policy_name" {
  description = "The policy's name."
}

variable "protected_project_ids" {
  description = "Project id and number of the project INSIDE the regular service perimeter"
  type        = "map"

  default {
    id     = "sample-project-id"
    number = "01010101"
  }
}

variable "public_project_ids" {
  description = "Project is and number of the project OUTSIDE of the regular service perimeter"
  type        = "map"

  default = {
    id     = "sample-project-id"
    number = "01010101"
  }
}

variable "members" {
  description = "An allowed list of members (users, groups, service accounts). The signed-in user originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, not present in any groups, etc.). Formats: user:{emailid}, group:{emailid}, serviceAccount:{emailid}"
  type        = "list"
  default     = [""]
}
