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
  version = "1.0.0"

  project = module.project1.project_id
  region  = var.region
  zone    = var.zone
  members = var.members
  network = module.vpc.network_self_link
  subnet  = module.vpc.subnets_self_links[0]
  service_account_roles_supplemental = [
    "roles/bigquery.admin",
    "roles/storage.admin",
  ]
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 1.5.0"

  project_id              = module.project1.project_id
  network_name            = "test-network"
  auto_create_subnetworks = false
  subnets = [
    {
      subnet_name   = "test-subnet"
      subnet_ip     = "10.127.0.0/20"
      subnet_region = var.region
    }
  ]
}

######################################
## Simulate Exfil to other GCP project
######################################

resource "google_project_iam_member" "bound_from_attacker" {
  project = module.project2.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${module.bastion.service_account}"
}
