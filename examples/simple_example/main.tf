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

provider "google" {
  version = "~> 2.0"
  region  = "${var.region}"
}

module "org-policy" {
  source      = "../../modules/policy"
  parent_id   = "111111"
  policy_name = "org-policy"
}

module "regular-service-perimeter-1" {
  source         = "../../modules/regular_service_perimeter"
  policy         = "${module.org-policy.policy_name}"
  perimeter_name = "regular-perimeter-1"
  description    = "Some description"
  resources      = []

  #restricted_services = [*]
  #access_levels = ["${module.access-level-device-lock.link}”, "${module.access_level_2.link}”]
  shared_resources = {
    all     = ["protected-project-id-3", "protected-project-3"]
    special = ["protected-project-4"]
  }
}
