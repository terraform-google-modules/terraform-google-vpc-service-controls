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
  version     = "~> 2.5.0"
  credentials = "${file("${var.credentials_path}")}"
}

module "org_policy" {
  source      = "../.."
  parent_id   = "${var.parent_id}"
  policy_name = "${var.policy_name}"
}

module "access_level_members" {
  source  = "../../modules/access_level"
  policy  = "${module.org_policy.policy_id}"
  name    = "terraform_members"
  members = "${var.members}"
}

module "regular_service_perimeter_1" {
  source         = "../../modules/regular_service_perimeter"
  policy         = "${module.org_policy.policy_id}"
  perimeter_name = "regular_perimeter_1"

  description = "Perimeter shielding bigquery project"
  resources   = ["${var.protected_project_ids["number"]}"]

  access_levels       = ["${module.access_level_members.name}"]
  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  shared_resources = {
    all = ["${var.protected_project_ids["number"]}"]
  }
}

module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
  version = "0.1.0"

  dataset_id        = "sample_dataset"
  dataset_name      = "sample_dataset"
  description       = "Dataset with a single table with one field"
  expiration        = "3600000"
  project_id        = "${var.protected_project_ids["id"]}"
  location          = "US"
  table_id          = "example_table"
  time_partitioning = "DAY"
  schema_file       = "sample_bq_schema.json"

  dataset_labels = {
    env      = "dev"
    billable = "true"
    owner    = "janesmith"
  }

  table_labels = {
    env      = "dev"
    billable = "true"
    owner    = "joedoe"
  }
}
