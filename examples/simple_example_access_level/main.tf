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

provider "google-beta" {
  version = "~> 2.3"

  #region  = "${var.region}"
  credentials = "${file("./credentials.json")}"
}

module "org-policy" {
  source      = "../../modules/policy"
  parent_id   = "${var.parent_id}"
  policy_name = "${var.policy_name}"
}

module "access-level-1" {
  source         = "../../modules/access_level"
  policy      = "${module.org-policy.policy_id}"
  name        = "device_policy"
  conditions =  {
     conditions  = [{
       device_policy = [{
        require_screen_lock = false
        os_constraints = [{
          os_type = "DESKTOP_CHROME_OS"
         }]
       }]
     }]
  }
}

module "regular-service-perimeter-1" {
  source         = "../../modules/regular_service_perimeter"
  policy         = "${module.org-policy.policy_id}"
  perimeter_name = "regular_perimeter_1"
  description    = "Some description"
  resources      = ["743286545054"]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  access_levels = ["${module.access-level-1.name}"]
  shared_resources = {
    all = ["743286545054"]
  }
}
