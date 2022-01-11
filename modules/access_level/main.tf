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

locals {
  output_name = google_access_context_manager_access_level.access_level.name
}

resource "google_access_context_manager_access_level" "access_level" {
  provider    = google
  parent      = "accessPolicies/${var.policy}"
  name        = "accessPolicies/${var.policy}/accessLevels/${var.name}"
  title       = var.name
  description = var.description

  basic {
    conditions {
      ip_subnetworks         = var.ip_subnetworks
      required_access_levels = var.required_access_levels
      members                = var.members
      negate                 = var.negate
      regions                = var.regions

      dynamic "device_policy" {
        for_each = var.require_corp_owned || var.require_screen_lock || length(var.allowed_encryption_statuses) > 0 || length(var.allowed_device_management_levels) > 0 || var.minimum_version != "" || var.os_type != "OS_UNSPECIFIED" ? [{}] : []

        content {
          require_screen_lock              = var.require_screen_lock
          allowed_encryption_statuses      = var.allowed_encryption_statuses
          allowed_device_management_levels = var.allowed_device_management_levels
          require_corp_owned               = var.require_corp_owned

          os_constraints {
            minimum_version = var.minimum_version
            os_type         = var.os_type
          }
        }
      }
    }

    combining_function = var.combining_function
  }
}
