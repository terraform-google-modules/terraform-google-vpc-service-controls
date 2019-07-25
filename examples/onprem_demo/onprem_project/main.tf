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

resource "google_project" "on_prem_network_project" {
  name                = "On Prem Network"
  project_id          = "${var.project_id}"
  org_id              = "${var.organization_id}"
  billing_account     = "${var.billing_account_id}"
  auto_create_network = false
}

resource "google_project_service" "gce_service" {
  project = "${google_project.on_prem_network_project.project_id}"
  service = "compute.googleapis.com"
}

resource "google_compute_network" "onprem-network" {
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
  name                            = "onprem-network"
  project                         = "${google_project.on_prem_network_project.project_id}"
  routing_mode                    = "REGIONAL"
  depends_on                      = ["google_project_service.gce_service"]
}

resource "google_compute_subnetwork" "onprem_subnet" {
  enable_flow_logs         = false
  ip_cidr_range            = "10.2.0.0/16"
  name                     = "vpc-subnet"
  network                  = "${google_compute_network.onprem-network.self_link}"
  private_ip_google_access = false
  project                  = "${google_project.on_prem_network_project.project_id}"
  region                   = "${var.region}"
}

resource "google_compute_address" "onprem_vpn_ip" {
  address_type = "EXTERNAL"
  name         = "onprem-vpn-ip"
  network_tier = "PREMIUM"
  project      = "${google_project.on_prem_network_project.project_id}"
  region       = "${var.region}"
  depends_on   = ["google_project_service.gce_service"]
}

resource "google_compute_router" "onprem_cloud_router" {
  bgp {
    advertise_mode = "DEFAULT"
    asn            = "64512"
  }

  name       = "onprem-cloud-router"
  network    = "${google_compute_network.onprem-network.self_link}"
  project    = "${google_project.on_prem_network_project.project_id}"
  region     = "${var.region}"
  depends_on = ["google_project_service.gce_service"]
}

resource "google_compute_vpn_gateway" "target_gateway" {
  name       = "target-vpn-gateway"
  network    = "${google_compute_network.onprem-network.self_link}"
  project    = "${google_project.on_prem_network_project.project_id}"
  region     = "${var.region}"
  depends_on = ["google_project_service.gce_service"]
}

resource "google_compute_forwarding_rule" "fr_for_vpn_gateway" {
  name        = "frforvpngateway"
  ip_protocol = "ESP"
  ip_address  = "${google_compute_address.onprem_vpn_ip.address}"
  target      = "${google_compute_vpn_gateway.target_gateway.self_link}"
  project     = "${google_project.on_prem_network_project.project_id}"
  region      = "${var.region}"
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "frforvpngatewayudp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = "${google_compute_address.onprem_vpn_ip.address}"
  target      = "${google_compute_vpn_gateway.target_gateway.self_link}"
  project     = "${google_project.on_prem_network_project.project_id}"
  region      = "${var.region}"
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "frforvpngatewayudp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = "${google_compute_address.onprem_vpn_ip.address}"
  target      = "${google_compute_vpn_gateway.target_gateway.self_link}"
  project     = "${google_project.on_prem_network_project.project_id}"
  region      = "${var.region}"
}

resource "google_compute_vpn_tunnel" "onprem_vpn_tunnel" {
  ike_version        = "2"
  name               = "onprem-vpn-tunnel"
  peer_ip            = "${var.ip_addr_cloud_vpn_router}"
  project            = "${google_project.on_prem_network_project.project_id}"
  region             = "${var.region}"
  router             = "${google_compute_router.onprem_cloud_router.self_link}"
  target_vpn_gateway = "${google_compute_vpn_gateway.target_gateway.name}"
  shared_secret      = "${var.vpn_shared_secret}"
}

resource "google_compute_router_interface" "onprem_router_interface" {
  name       = "onprem-router-interface"
  router     = "${google_compute_router.onprem_cloud_router.name}"
  region     = "${var.region}"
  ip_range   = "169.254.1.1/30"
  vpn_tunnel = "${google_compute_vpn_tunnel.onprem_vpn_tunnel.self_link}"
  project    = "${google_project.on_prem_network_project.project_id}"
}

resource "google_compute_router_peer" "onprem_router_peer" {
  name                      = "peer-1"
  router                    = "${google_compute_router.onprem_cloud_router.name}"
  region                    = "${var.region}"
  peer_ip_address           = "169.254.1.2"
  peer_asn                  = 64513
  advertised_route_priority = 100
  interface                 = "${google_compute_router_interface.onprem_router_interface.name}"
  project                   = "${google_project.on_prem_network_project.project_id}"
}

resource "google_compute_route" "onprem_to_vpn_route" {
  name                = "onprem-to-vpn-route"
  network             = "${google_compute_network.onprem-network.self_link}"
  dest_range          = "10.7.0.0/16"
  priority            = 1000
  project             = "${google_project.on_prem_network_project.project_id}"
  next_hop_vpn_tunnel = "${google_compute_vpn_tunnel.onprem_vpn_tunnel.self_link}"
}

/**********************************************/
/***** BEGIN JUMPHOST AND FWD PROXY VM'S ******/
/**********************************************/
resource "google_compute_instance" "forward_proxy_instance" {
  boot_disk {
    auto_delete = true
    device_name = "forward-proxy-instance"

    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-9-stretch-v20190423"
      size  = "10"
      type  = "pd-standard"
    }
  }

  can_ip_forward      = true
  deletion_protection = false
  labels              = {}
  machine_type        = "n1-standard-1"
  metadata            = {}
  name                = "forward-proxy-instance"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    network    = "${google_compute_network.onprem-network.self_link}"
    subnetwork = "${google_compute_subnetwork.onprem_subnet.self_link}"
    network_ip = "10.2.0.2"
  }

  project = "${google_project.on_prem_network_project.project_id}"

  metadata_startup_script = "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; sysctl -w net.ipv4.ip_forward=1"

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  tags       = ["forward-proxy"]
  zone       = "${var.region}-b"
  depends_on = ["google_project_service.gce_service"]
}

resource "google_compute_instance" "windows_jumphost" {
  boot_disk {
    auto_delete = true
    device_name = "windows-jumphost"

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

  name = "windows-jumphost"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    network    = "${google_compute_network.onprem-network.self_link}"
    subnetwork = "${google_compute_subnetwork.onprem_subnet.self_link}"
    network_ip = "10.2.0.3"
  }

  project = "${google_project.on_prem_network_project.project_id}"

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags       = ["forward-proxy"]
  zone       = "${var.region}-b"
  depends_on = ["google_project_service.gce_service"]
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
  network       = "${google_compute_network.onprem-network.self_link}"
  priority      = "1000"
  project       = "${google_project.on_prem_network_project.project_id}"
  source_ranges = ["10.0.0.0/8"]
  target_tags   = ["forward-proxy"]
}

resource "google_compute_firewall" "allow_rdp_ssh_from_internet" {
  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  direction     = "INGRESS"
  disabled      = false
  name          = "allow-rdp-ssh-from-internet"
  network       = "${google_compute_network.onprem-network.self_link}"
  priority      = "1000"
  project       = "${google_project.on_prem_network_project.project_id}"
  source_ranges = ["0.0.0.0/0"]
}

/*************************/
/***** BEGIN ROUTES ******/
/*************************/

resource "google_compute_route" "default_for_all" {
  dest_range  = "0.0.0.0/0"
  name        = "default-for-all"
  network     = "${google_compute_network.onprem-network.self_link}"
  next_hop_ip = "${google_compute_instance.forward_proxy_instance.network_interface.0.network_ip}"
  priority    = "1000"
  project     = "${google_project.on_prem_network_project.project_id}"
}

resource "google_compute_route" "default_for_forward_proxy" {
  dest_range       = "0.0.0.0/0"
  name             = "default-for-forward-proxy"
  network          = "${google_compute_network.onprem-network.self_link}"
  next_hop_gateway = "https://www.googleapis.com/compute/v1/projects/${google_project.on_prem_network_project.project_id}/global/gateways/default-internet-gateway"
  priority         = "100"
  project          = "${google_project.on_prem_network_project.project_id}"
  tags             = ["forward-proxy"]
}
