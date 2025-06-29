
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

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

module "example" {
  source = "../../../examples/scoped_example_access_level_dry_run"

  parent_id   = var.parent_id
  policy_name = "int_test_vpc_al_dry_run_${random_string.suffix.result}"
  scopes      = var.scopes

  protected_project_number = var.protected_project_ids["number"]
  ip_subnetworks           = ["192.0.2.0/24"]
}
