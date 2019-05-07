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

output "parent_id" {
  value = "${var.parent_id}"
}

output "policy_name" {
  value = "${var.policy_name}"
}

output "protected_project_id" {
  value = "${var.protected_project_ids["id"]}"
}

output "public_project_id" {
  value = "${var.public_project_ids["id"]}"
}

output "dataset_id" {
  value = "${module.example.dataset_id}"
}

output "table_id" {
  value = "${module.example.table_id}"
}
