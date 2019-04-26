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

output "parent_id" {
  description = "The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent."
  value = "${var.parent_id}"
}

output "policy_name" {
  description = "Name of the parent policy"
  value = "${var.policy_name}"
}

output "protected_project_id" {
  description = "Project id of the project INSIDE the regular service perimeter"
  value = "${var.protected_project_ids["id"]}"
}

output "public_project_id" {
  description = "Project id of the project OUTSIDE of the regular service perimeter"
  value = "${var.public_project_ids["id"]}"
}

output "dataset_id" {
  value = "${module.bigquery.dataset_id}"
}

output "table_id" {
  value = "${module.bigquery.table_id}"
}