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

module "access_context_manager_policy" {
  source  = "terraform-google-modules/vpc-service-controls/google"
  version = "~> 7.0"

  parent_id   = var.parent_id
  policy_name = var.policy_name
}

module "access_level_1" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 7.0"

  policy         = module.access_context_manager_policy.policy_id
  name           = "single_ip_policy"
  ip_subnetworks = var.ip_subnetworks
  description    = "Some description"
}

module "regular_service_perimeter_1" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version = "~> 7.0"

  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = "regular_perimeter_1"
  description    = "Some description"
  resources      = [var.protected_project_id]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  access_levels = [module.access_level_1.name]

  shared_resources = {
    all = [var.protected_project_id]
  }
}
