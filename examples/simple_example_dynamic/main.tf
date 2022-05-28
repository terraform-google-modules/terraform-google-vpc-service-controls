/**
 * Copyright 2022 Google LLC
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
  source      = "../.."
  parent_id   = var.parent_id
  policy_name = var.policy_name
  scopes = var.scopes
}

module "bridge" {
  source         = "../../modules/bridge_service_perimeter"
  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = "bridge_perimeter_1"
  description    = "Some description"

  resources     = [module.project_one.project_number, module.project_two.project_number, module.project_three.project_number]
  resource_keys = ["one", "two", "three"]

  depends_on = [
    module.regular_service_perimeter_1,
    module.regular_service_perimeter_2
  ]
}

module "regular_service_perimeter_1" {
  source         = "../../modules/regular_service_perimeter"
  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = "regular_perimeter_1"
  description    = "Some description"
  resources      = [module.project_one.project_number]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  shared_resources = {
    all = [module.project_one.project_number]
  }
}

module "regular_service_perimeter_2" {
  source         = "../../modules/regular_service_perimeter"
  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = "regular_perimeter_2"
  description    = "Some description"
  resources      = [module.project_two.project_number, module.project_three.project_number]
  resource_keys  = ["two", "three"]

  restricted_services = ["storage.googleapis.com"]

  shared_resources = {
    all = [module.project_two.project_number, module.project_three.project_number]
  }
}
