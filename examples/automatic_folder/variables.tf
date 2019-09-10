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
  type        = string
  description = "The ID of the project to which resources will be applied."
}

variable "parent_id" {
  description = "The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent (ID)."
  type        = string
}

variable "policy_name" {
  description = "The policy's name."
  type        = string
}

variable "members" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = list(string)
}

variable "folder_id" {
  description = "Folder ID to watch for projects."
  type        = string
}

variable "perimeter_name" {
  description = "Name of perimeter."
  type        = string
  default     = "regular_perimeter"
}

variable "restricted_services" {
  description = "List of services to restrict."
  type        = list(string)
}

variable "region" {
  type        = string
  description = "The region in which resources will be applied."
}
