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

variable "service_account_file" {}

// you can get your access policy name (which is actually a number) by running:
// `gcloud organizations list` <- to get your org number
// `gcloud access-context-manager policies list --organization=<your org number>`   <- to get the access policy name
variable "access_policy_name" {}

variable "protected_projects_list" {
	type = "list"
}