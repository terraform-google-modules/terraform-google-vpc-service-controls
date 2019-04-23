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
  description = "Project id and number of the project within the regular service perimeter"
  type = "map"
  default  {
    id = "sample-project-id"
    number = "01010101"
  }
}

variable "public_project_ids" {
  description = "Project is and number of the project outside of the regular service perimeter"
  type = "map"
  default = {
    id = "sample-project-id"
    number = "01010101"
  }
}
