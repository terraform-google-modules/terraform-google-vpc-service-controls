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

provider "google" {
  version = "~> 3.19.0"
}

module "access_context_manager_policy" {
  source      = "../.."
  parent_id   = var.parent_id
  policy_name = var.policy_name
}

module "access_level_members" {
  source      = "../../modules/access_level"
  description = "Simple Example Access Level"
  policy      = module.access_context_manager_policy.policy_id
  name        = var.access_level_name
  members     = var.members
}

module "access_level_members_dry_run" {
  source      = "../../modules/access_level"
  description = "Simple Example Access Level (dry-run)"
  policy      = module.access_context_manager_policy.policy_id
  name        = var.access_level_name_dry_run
  members     = var.members
}


resource "null_resource" "wait_for_members" {
  provisioner "local-exec" {
    command = "sleep 60"
  }

  depends_on = [module.access_level_members]
}

module "regular_service_perimeter_1" {
  source         = "../../modules/regular_service_perimeter_dry_run"
  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = var.perimeter_name

  description = "Perimeter shielding bigquery project ${null_resource.wait_for_members.id}"
  resources   = [var.protected_project_ids["number"]]

  access_levels       = [module.access_level_members.name]
  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  resources_dry_run           = [var.protected_project_ids["number"]]
  access_levels_dry_run       = [module.access_level_members_dry_run.name]
  restricted_services_dry_run = ["storage.googleapis.com"]

  shared_resources = {
    all = [var.protected_project_ids["number"]]
  }
}

module "bigquery" {
  source            = "terraform-google-modules/bigquery/google"
  version           = "2.0.0"
  dataset_id        = var.dataset_id
  dataset_name      = var.dataset_id
  description       = "Dataset with a single table with one field"
  expiration        = "3600000"
  project_id        = var.protected_project_ids["id"]
  location          = "US"
  time_partitioning = "DAY"

  dataset_labels = {
    env      = "dev"
    billable = "true"
    owner    = "janesmith"
  }

  tables = [{
    table_id = "example_table",
    schema   = "sample_bq_schema.json",
    labels = {
      env      = "dev"
      billable = "true"
      owner    = "joedoe"
    },
  }, ]
}
