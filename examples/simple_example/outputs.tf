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

output "policy_name" {
  description = "Name of the parent policy"
  value       = "${var.policy_name}"
}

output "protected_project_id" {
  description = "Project id of the project INSIDE the regular service perimeter"
  value       = "${var.protected_project_ids["id"]}"
}

output "dataset_id" {
  description = "Unique id for the BigQuery dataset being provisioned"
  value       = "${module.bigquery.dataset_id}"
}

output "table_id" {
  description = "Unique id for the BigQuery table being provisioned"
  value       = "${module.bigquery.table_id}"
}
