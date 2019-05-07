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

variable "policy" {
  description = "Name of the parent policy"
}

variable "description" {
  description = "Description of the bridge perimeter"
}

variable "perimeter_name" {
  description = "Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores"
}

variable "resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = "list"
  default     = []
}
