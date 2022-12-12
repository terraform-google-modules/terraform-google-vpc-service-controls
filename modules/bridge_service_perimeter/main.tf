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

resource "google_access_context_manager_service_perimeter" "bridge_service_perimeter" {
  provider       = google
  parent         = "accessPolicies/${var.policy}"
  perimeter_type = "PERIMETER_TYPE_BRIDGE"
  name           = "accessPolicies/${var.policy}/servicePerimeters/${var.perimeter_name}"
  title          = var.perimeter_name
  description    = var.description

  lifecycle {
    ignore_changes = [status]
  }
}

locals {
  resource_keys = var.resource_keys != null ? var.resource_keys : var.resources
  resources = {
    for rk in local.resource_keys :
    rk => var.resources[index(local.resource_keys, rk)]
  }
}

resource "google_access_context_manager_service_perimeter_resource" "service_perimeter_resource" {
  for_each       = local.resources
  perimeter_name = google_access_context_manager_service_perimeter.bridge_service_perimeter.name
  resource       = "projects/${each.value}"
}
