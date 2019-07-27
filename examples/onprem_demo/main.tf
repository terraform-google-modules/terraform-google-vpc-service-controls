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

module "onprem_network" {
  source                      = "./onprem_project"
  project_id                  = "${var.onprem_project_id}"
  organization_id             = "${var.organization_id}"
  billing_account_id          = "${var.billing_account_id}"
  region                      = "${var.region}"
  vpn_shared_secret           = "${var.vpn_shared_secret}"
  ip_addr_cloud_vpn_router = "${module.vpc_sc_network.ip_addr_cloud_vpn_router}"
}

module "vpc_sc_network" {
  source                       = "./vpc_sc_project"
  project_id                   = "${var.vpc_sc_project_id}"
  organization_id              = "${var.organization_id}"
  billing_account_id           = "${var.billing_account_id}"
  region                       = "${var.region}"
  vpn_shared_secret            = "${var.vpn_shared_secret}"
  ip_addr_onprem_vpn_router = "${module.onprem_network.ip_addr_onprem_vpn_router}"
  access_policy_name           = "${var.access_policy_name}"
}
