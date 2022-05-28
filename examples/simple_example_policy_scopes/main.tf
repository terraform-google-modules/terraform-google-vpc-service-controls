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

# Top-level folder under an organization.
resource "google_folder" "folder" {
  display_name = var.folder_name
  parent       = var.parent_id
}

module "access_context_manager_policy" {
  source      = "../.."
  parent_id   = var.parent_id
  policy_name = var.policy_name
  scopes      = [google_folder.folder.name]
}

module "access_level_members" {
  source      = "../../modules/access_level"
  description = "Simple Example Access Level"
  policy      = module.access_context_manager_policy.policy_id
  name        = var.access_level_name
  members     = var.members
  regions     = var.regions
}

resource "null_resource" "wait_for_members" {
  provisioner "local-exec" {
    command = "sleep 60"
  }

  depends_on = [module.access_level_members]
}

module "regular_service_perimeter_1" {
  source         = "../../modules/regular_service_perimeter"
  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = var.perimeter_name

  description = "Perimeter shielding bigquery project ${null_resource.wait_for_members.id}"
  resources   = [var.protected_project_ids["number"]]

  access_levels       = [module.access_level_members.name]
  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  shared_resources = {
    all = [var.protected_project_ids["number"]]
  }
}

module "bigquery" {
  source                      = "terraform-google-modules/bigquery/google"
  version                     = "5.3.0"
  dataset_id                  = var.dataset_id
  dataset_name                = var.dataset_id
  description                 = "Dataset with a single table with one field"
  default_table_expiration_ms = "3600000"
  project_id                  = var.protected_project_ids["id"]
  location                    = "US"
  access                      = []
  deletion_protection         = false

  tables = [
    {
      table_id = "example_table",
      schema   = file("sample_bq_schema.json")
      time_partitioning = {
        type                     = "DAY",
        field                    = null,
        require_partition_filter = false,
        expiration_ms            = null,
      },
      range_partitioning = null,
      expiration_time    = null,
      clustering         = [],
      labels = {
        env      = "dev"
        billable = "true"
        owner    = "joedoe"
      },
    }
  ]
}
