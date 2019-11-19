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


###########################
## Source Bastion Host
###########################

module "bastion" {
  source  = "terraform-google-modules/bastion-host/google"
  version = "0.2.0"

  project = var.project1_id
  region  = var.region
  zone    = var.zone
  members = var.members
  network = google_compute_network.source_network.self_link
  subnet  = google_compute_subnetwork.source_subnet.self_link
  service_account_roles_supplemental = [
    "roles/bigquery.admin",
    "roles/storage.admin",
  ]
}

resource "google_compute_network" "source_network" {
  project                 = var.project1_id
  name                    = "test-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "source_subnet" {
  project                  = var.project1_id
  name                     = "test-subnet"
  region                   = var.region
  ip_cidr_range            = "10.127.0.0/20"
  network                  = google_compute_network.source_network.self_link
  private_ip_google_access = true
}

######################################
## Simulate Exfil to other GCP project
######################################

resource "google_project_iam_member" "bound_from_attacker" {
  project = var.project2_id
  role    = "roles/owner"
  member  = "serviceAccount:${module.bastion.service_account}"
}
