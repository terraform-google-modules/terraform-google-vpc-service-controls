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

output "policy_name" {
  description = "Name of the parent policy"
  value       = var.policy_name
}

output "protected_project_ids" {
  description = "Project ids of the projects INSIDE the regular service perimeter"
  value       = local.projects
}

output "function_service_account" {
  description = "Email of the watcher function's Service Account"
  value       = google_service_account.watcher.email
}

output "organization_id" {
  description = "Organization ID hosting the perimeter"
  value       = local.parent_id
}

output "project_id" {
  value       = var.project_id
  description = "The ID of the project hosting the watcher function."
}

output "folder_id" {
  value       = var.folder_id
  description = "The ID of the watched folder."
}
