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
  credentials = "${file("${var.service_account_file}")}"
}

resource "google_access_context_manager_service_perimeter" "service_perimeter" {
  parent      = "accessPolicies/${var.access_policy_name}"
  name        = "accessPolicies/${var.access_policy_name}/servicePerimeters/restrict_all"
  title       = "restrict_all"
  status {
    resources = "${var.protected_projects_list}"

    // Complete list of VPC Service Control services can be found at:
    // https://cloud.google.com/vpc-service-controls/docs/supported-products#apis_and_service_perimeters
    restricted_services = ["bigquery.googleapis.com",
                           "bigtable.googleapis.com",
                           "dataflow.googleapis.com",
                           "dataproc.googleapis.com",
                           "cloudkms.googleapis.com",
                           "pubsub.googleapis.com",
                           "spanner.googleapis.com",
                           "storage.googleapis.com",
                           "containerregistry.googleapis.com",
                           "container.googleapis.com",
                           "gkeconnect.googleapis.com",
                           "logging.googleapis.com"]
  }
}

