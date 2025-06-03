/**
 * Copyright 2024 Google LLC
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

locals {
  dry_run = (length(var.restricted_services_dry_run) > 0 || length(var.resources_dry_run) > 0 || length(var.access_levels_dry_run) > 0 || !contains(var.vpc_accessible_services_dry_run, "*"))
}

resource "google_access_context_manager_service_perimeter" "regular_service_perimeter" {
  provider       = google
  parent         = "accessPolicies/${var.policy}"
  perimeter_type = "PERIMETER_TYPE_REGULAR"
  name           = "accessPolicies/${var.policy}/servicePerimeters/${var.perimeter_name}"
  title          = var.perimeter_name
  description    = var.description

  status {
    restricted_services = var.restricted_services
    access_levels = formatlist(
      "accessPolicies/${var.policy}/accessLevels/%s",
      var.access_levels
    )



    dynamic "vpc_accessible_services" {
      for_each = contains(var.vpc_accessible_services, "*") ? [] : [var.vpc_accessible_services]
      content {
        enable_restriction = true
        allowed_services   = vpc_accessible_services.value
      }
    }
  }


  dynamic "spec" {
    for_each = local.dry_run ? ["dry-run"] : []
    content {
      restricted_services = var.restricted_services_dry_run
      resources           = [for item in var.resources_dry_run : can(regex("global/networks", item)) ? format("//compute.googleapis.com/%s", item) : format("projects/%s", item)]
      access_levels = formatlist(
        "accessPolicies/${var.policy}/accessLevels/%s",
        var.access_levels_dry_run
      )



      dynamic "vpc_accessible_services" {
        for_each = contains(var.vpc_accessible_services_dry_run, "*") ? [] : [var.vpc_accessible_services_dry_run]
        content {
          enable_restriction = true
          allowed_services   = vpc_accessible_services.value
        }
      }
    }
  }
  use_explicit_dry_run_spec = local.dry_run

  lifecycle {
    ignore_changes = [
      status[0].resources,
      status[0].ingress_policies, # Allows ingress policies to be managed by google_access_context_manager_service_perimeter_ingress_policy resources
      status[0].egress_policies,  # Allows egress policies to be managed by google_access_context_manager_service_perimeter_egress_policy resources
      spec[0].resources,
      spec[0].ingress_policies, # Allows dry-run ingress policies to be managed by google_access_context_manager_service_perimeter_ingress_policy resources
      spec[0].egress_policies   # Allows dry-run egress policies to be managed by google_access_context_manager_service_perimeter_egress_policy resources
    ]
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
  perimeter_name = google_access_context_manager_service_perimeter.regular_service_perimeter.name
  resource       = can(regex("global/networks", each.value)) ? "//compute.googleapis.com/${each.value}" : "projects/${each.value}"
}
