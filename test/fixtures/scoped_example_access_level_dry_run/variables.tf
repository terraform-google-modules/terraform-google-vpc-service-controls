/**
 * Copyright 2025 Google LLC
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

variable "protected_project_ids" {
  description = "Project id and number of the project INSIDE the regular service perimeter. This map variable expects an \"id\" for the project id and \"number\" key for the project number."
  type        = object({ id = string, number = number })
}

variable "scopes" {
  description = "Folder or project on which this policy is applicable. Format: 'folders/FOLDER_ID' or 'projects/PROJECT_NUMBER'"
  type        = list(string)
  default     = []
}
