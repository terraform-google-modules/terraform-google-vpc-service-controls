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

resource "google_project" "vpc_sc_network_project" {
  name                = "VPC SC Network"
  project_id          = "${var.project_id}"
  org_id              = "${var.organization_id}"
  billing_account     = "${var.billing_account_id}"
  auto_create_network = false
}

resource "google_project_service" "gce_service" {
  project = "${google_project.vpc_sc_network_project.project_id}"
  service = "compute.googleapis.com"
}

resource "google_project_service" "dns_service" {
  project = "${google_project.vpc_sc_network_project.project_id}"
  service = "dns.googleapis.com"
}

resource "google_compute_network" "test-vpc" {
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
  name                            = "test-vpc"
  project                         = "${google_project.vpc_sc_network_project.project_id}"
  routing_mode                    = "REGIONAL"
  depends_on                      = ["google_project_service.gce_service"]
}

resource "google_compute_subnetwork" "vpc_subnet" {
  enable_flow_logs         = false
  ip_cidr_range            = "10.7.0.0/16"
  name                     = "vpc-subnet"
  network                  = "${google_compute_network.test-vpc.self_link}"
  private_ip_google_access = true
  project                  = "${google_project.vpc_sc_network_project.project_id}"
  region                   = "${var.region}"
}

resource "google_compute_address" "vpc_sc_vpn_ip" {
  address_type = "EXTERNAL"
  name         = "vpc-sc-vpn-ip"
  network_tier = "PREMIUM"
  project      = "${google_project.vpc_sc_network_project.project_id}"
  region       = "${var.region}"
  depends_on   = ["google_project_service.gce_service"]
}

resource "google_compute_router" "vpc_sc_cloud_router" {
  bgp {
    advertise_mode = "DEFAULT"
    asn            = "64513"
  }

  name    = "vpc-sc-cloud-router"
  network = "${google_compute_network.test-vpc.self_link}"
  project = "${google_project.vpc_sc_network_project.project_id}"
  region  = "${var.region}"
}

resource "google_compute_vpn_gateway" "target_gateway" {
  name    = "target-vpn-gateway"
  network = "${google_compute_network.test-vpc.self_link}"
  project = "${google_project.vpc_sc_network_project.project_id}"
  region  = "${var.region}"
}

resource "google_compute_forwarding_rule" "fr_for_vpn_gateway" {
  name        = "frforvpngateway"
  ip_protocol = "ESP"
  ip_address  = "${google_compute_address.vpc_sc_vpn_ip.address}"
  target      = "${google_compute_vpn_gateway.target_gateway.self_link}"
  project     = "${google_project.vpc_sc_network_project.project_id}"
  region      = "${var.region}"
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "frforvpngatewayudp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = "${google_compute_address.vpc_sc_vpn_ip.address}"
  target      = "${google_compute_vpn_gateway.target_gateway.self_link}"
  project     = "${google_project.vpc_sc_network_project.project_id}"
  region      = "${var.region}"
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "frforvpngatewayudp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = "${google_compute_address.vpc_sc_vpn_ip.address}"
  target      = "${google_compute_vpn_gateway.target_gateway.self_link}"
  project     = "${google_project.vpc_sc_network_project.project_id}"
  region      = "${var.region}"
}

resource "google_compute_vpn_tunnel" "vpc_sc_vpn_tunnel" {
  ike_version        = "2"
  name               = "vpc-sc-vpn-tunnel"
  peer_ip            = "${var.ip_addr_onprem_vpn_router}"
  project            = "${google_project.vpc_sc_network_project.project_id}"
  region             = "${var.region}"
  router             = "${google_compute_router.vpc_sc_cloud_router.self_link}"
  target_vpn_gateway = "${google_compute_vpn_gateway.target_gateway.name}"
  shared_secret      = "${var.vpn_shared_secret}"
}

resource "google_compute_router_interface" "vpc_sc_router_interface" {
  name       = "vpc-sc-router-interface"
  router     = "${google_compute_router.vpc_sc_cloud_router.name}"
  region     = "${var.region}"
  ip_range   = "169.254.1.2/30"
  vpn_tunnel = "${google_compute_vpn_tunnel.vpc_sc_vpn_tunnel.self_link}"
  project    = "${google_project.vpc_sc_network_project.project_id}"
}

resource "google_compute_router_peer" "vpc_sc_router_peer" {
  name                      = "peer-1"
  router                    = "${google_compute_router.vpc_sc_cloud_router.name}"
  region                    = "${var.region}"
  peer_ip_address           = "169.254.1.1"
  peer_asn                  = 64512
  advertised_route_priority = 100
  interface                 = "${google_compute_router_interface.vpc_sc_router_interface.name}"
  project                   = "${google_project.vpc_sc_network_project.project_id}"
}

resource "google_compute_route" "vpc_sc_to_vpn_route" {
  name                = "vpc-sc-to-vpn-route"
  network             = "${google_compute_network.test-vpc.self_link}"
  dest_range          = "0.0.0.0/0"
  priority            = 1000
  project             = "${google_project.vpc_sc_network_project.project_id}"
  next_hop_vpn_tunnel = "${google_compute_vpn_tunnel.vpc_sc_vpn_tunnel.self_link}"
}

/**********************************************/
/***** BEGIN JUMPHOST AND FWD PROXY VM'S ******/
/**********************************************/

resource "google_compute_instance" "vpc_sc_windows_instance" {
  boot_disk {
    auto_delete = true
    device_name = "vpc-sc-windows-instance"

    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/windows-cloud/global/images/windows-server-2019-dc-v20190411"
      size  = "50"
      type  = "pd-ssd"
    }
  }

  can_ip_forward      = false
  deletion_protection = false
  labels              = {}
  machine_type        = "n1-standard-2"

  name = "vpc-sc-windows-instance"

  network_interface {
    network    = "${google_compute_network.test-vpc.self_link}"
    subnetwork = "${google_compute_subnetwork.vpc_subnet.self_link}"
    network_ip = "10.7.0.2"
  }

  project = "${google_project.vpc_sc_network_project.project_id}"

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  zone = "${var.region}-b"
}

/*********************************/
/***** BEGIN FIREWALL RULES ******/
/*********************************/

resource "google_compute_firewall" "allow_all_from_internal" {
  allow {
    protocol = "all"
  }

  direction     = "INGRESS"
  disabled      = false
  name          = "allow-all-from-internal"
  network       = "${google_compute_network.test-vpc.self_link}"
  priority      = "1000"
  project       = "${google_project.vpc_sc_network_project.project_id}"
  source_ranges = ["10.0.0.0/8"]
}

/*************************/
/***** BEGIN ROUTES ******/
/*************************/

resource "google_compute_route" "google_private_access_route" {
  dest_range       = "199.36.153.4/30"
  name             = "google-private-access-route"
  network          = "${google_compute_network.test-vpc.self_link}"
  next_hop_gateway = "https://www.googleapis.com/compute/v1/projects/${google_project.vpc_sc_network_project.project_id}/global/gateways/default-internet-gateway"
  priority         = "1000"
  project          = "${google_project.vpc_sc_network_project.project_id}"
}

/******************************/
/***** BEGIN PRIVATE DNS ******/
/******************************/
// Steps below are reproduced from gcloud comands here:
// https://cloud.google.com/vpc-service-controls/docs/set-up-private-connectivity#configuring_dns_with 

resource "google_dns_managed_zone" "google_private_access_zone" {
  name        = "google-private-access-zone"
  dns_name    = "googleapis.com."
  project     = "${google_project.vpc_sc_network_project.project_id}"
  description = "Private DNS zone for resolving queries to Google APIs using Google Private Access"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = "${google_compute_network.test-vpc.self_link}"
    }
  }

  depends_on = ["google_project_service.dns_service"]
}

resource "google_dns_record_set" "cname" {
  name         = "*.googleapis.com."
  managed_zone = "${google_dns_managed_zone.google_private_access_zone.name}"
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["restricted.googleapis.com."]
  project      = "${google_project.vpc_sc_network_project.project_id}"
}

resource "google_dns_record_set" "a" {
  name         = "restricted.googleapis.com."
  managed_zone = "${google_dns_managed_zone.google_private_access_zone.name}"
  type         = "A"
  ttl          = 300
  rrdatas      = ["199.36.153.4", "199.36.153.5", "199.36.153.6", "199.36.153.7"]
  project      = "${google_project.vpc_sc_network_project.project_id}"
}

/***************************************/
/***** BEGIN VPC SERVICE CONTROLS ******/
/***************************************/

module "regular_service_perimeter_1" {
  source         = "../../../modules/regular_service_perimeter"
  policy         = "${var.access_policy_name}"
  perimeter_name = "regular_perimeter_1"
  description    = "VPC Service Controls perimeter"
  resources      = ["${google_project.vpc_sc_network_project.number}"]

  restricted_services = ["bigquery.googleapis.com",
    "cloudkms.googleapis.com",
    "bigtable.googleapis.com",
    "dataflow.googleapis.com",
    "dataproc.googleapis.com",
    "pubsub.googleapis.com",
    "spanner.googleapis.com",
    "storage.googleapis.com",
    "logging.googleapis.com",
  ]
}
