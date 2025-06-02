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

output "policy_id" {
  description = "Resource name of the AccessPolicy."
  value       = module.example.policy_id
}

output "policy_name" {
  description = "Name of the parent policy"
  value       = module.example.policy_name
}

output "service_perimeter_name" {
  description = "Service perimeter name"
  value       = module.example.service_perimeter_name
}

output "protected_project_id" {
  description = "Project id of the project INSIDE the regular service perimeter"
  value       = module.example.protected_project_id
}
