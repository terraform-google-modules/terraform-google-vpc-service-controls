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

output "ip_addr_onprem_vpn_router" {
  value       = "${google_compute_address.onprem_vpn_ip.address}"
  description = "IP address of the VPN router in the onprem network project"
}

output "windows_onprem_public_ip" {
  value       = "${google_compute_instance.windows_jumphost.network_interface.0.access_config.0.nat_ip}"
  description = "Public IP address for the 'onprem' Windows jumphost"
}
