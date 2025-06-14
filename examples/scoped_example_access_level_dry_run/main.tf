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
  version = "~> 7.1"

  parent_id   = var.parent_id
  policy_name = var.policy_name
  scopes      = var.scopes
}

module "access_level_1" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 7.1"

  policy         = module.access_context_manager_policy.policy_id
  name           = "single_ip_policy"
  ip_subnetworks = var.ip_subnetworks
  description    = "Some description"
}

module "access_level_2" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 7.1"

  policy         = module.access_context_manager_policy.policy_id
  name           = "single_ip_policy_dry_run"
  ip_subnetworks = var.ip_subnetworks
  description    = "Some description"
}

resource "time_sleep" "wait_for_access_levels" {
  create_duration  = "90s"
  destroy_duration = "90s"

  depends_on = [
    module.access_level_1,
    module.access_level_2
  ]
}

module "regular_service_perimeter_1" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version = "~> 7.1"

  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = "regular_perimeter_1_dry_run"
  description    = "Some description"

  resources           = [var.protected_project_number]
  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]
  access_levels       = [module.access_level_1.name]

  resources_dry_run           = [var.protected_project_number]
  restricted_services_dry_run = ["storage.googleapis.com"]
  access_levels_dry_run       = [module.access_level_2.name]

  shared_resources = {
    all = [var.protected_project_number]
  }

  depends_on = [time_sleep.wait_for_access_levels]
}
