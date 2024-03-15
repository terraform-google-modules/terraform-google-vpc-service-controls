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

resource "random_id" "random_suffix" {
  byte_length = 2
}

module "access_context_manager_policy" {
  source  = "terraform-google-modules/vpc-service-controls/google"
  version = "~> 5.0"

  parent_id   = var.parent_id
  policy_name = "int_test_vpc_sc_policy_${random_id.random_suffix.hex}"
}

# Create Network with a subnetwork and private service access for both netapp.servicenetworking.goog and servicenetworking.googleapis.com

resource "google_compute_network" "network1" {
  name                    = "vpc-a"
  project                 = var.project_id
  auto_create_subnetworks = false
  description             = "test network"
}

resource "google_compute_subnetwork" "network1_us_central1" {
  name                     = "vpc-a-us-central1"
  ip_cidr_range            = "10.0.0.0/24"
  region                   = "us-central1"
  project                  = var.project_id
  network                  = google_compute_network.network1.self_link
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "network1_us_east1" {
  name                     = "vpc-a-us-east1"
  ip_cidr_range            = "10.0.1.0/24"
  region                   = "us-east1"
  project                  = var.project_id
  network                  = google_compute_network.network1.self_link
  private_ip_google_access = true
}

resource "google_compute_network" "network2" {
  name                    = "vpc-b"
  project                 = var.project_id
  auto_create_subnetworks = false
  description             = "test network b"
}

resource "google_compute_subnetwork" "network2_us_central1" {
  name                     = "vpc-b-us-central1"
  ip_cidr_range            = "10.0.10.0/24"
  region                   = "us-central1"
  project                  = var.project_id
  network                  = google_compute_network.network2.self_link
  private_ip_google_access = true
}

module "access_level_vpc_ranges" {
  # source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  # version = "~> 5.0"
  source      = "imrannayer/vpc-service-controls/google//modules/access_level"
  policy      = module.access_context_manager_policy.policy_id
  name        = "vpc_ip_address_policy"
  description = "access level for vpc ip addresses"
  vpc_network_sources = {
    "vpc_a" = {
      network_id = google_compute_network.network1.id
      ip_address_ranges = [
        "10.0.0.0/24",
        "192.169.0.0/16",
      ]
    }
    "vpc_b" = {
      network_id = google_compute_network.network2.id
    }
  }
  depends_on = [
    google_compute_subnetwork.network1_us_central1,
    google_compute_subnetwork.network1_us_east1,
    google_compute_subnetwork.network2_us_central1,
  ]
}
