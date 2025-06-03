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

output "project_id" {
  value = module.project-vpc-service-controls.project_id
}

output "sa_key" {
  value     = google_service_account_key.int_test.private_key
  sensitive = true
}

output "sa_email" {
  value = google_service_account.int_test.email
}

output "parent_id" {
  value = var.org_id
}

output "protected_project_ids" {
  value = {
    id     = module.project-vpc-service-controls-policy-0.project_id
    number = module.project-vpc-service-controls-policy-0.project_number
  }
}

output "public_project_ids" {
  value = {
    id     = module.project-vpc-service-controls-policy-1.project_id
    number = module.project-vpc-service-controls-policy-1.project_number
  }
}

output "members" {
  value = [
    "serviceAccount:${google_service_account.int_test.email}",
    "serviceAccount:${google_service_account.test_policy[0].email}",
    "serviceAccount:${google_service_account.test_policy[1].email}"
  ]
}

output "scopes" {
  value = ["projects/${module.project-vpc-service-controls-policy-0.project_number}"]
}
