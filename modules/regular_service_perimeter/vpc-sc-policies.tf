/**
 * Copyright 2025 Google LLC
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

resource "google_access_context_manager_service_perimeter_ingress_policy" "ingress_policies" {
  for_each = { for k, v in var.ingress_policies : k => v }

  perimeter = google_access_context_manager_service_perimeter.regular_service_perimeter.name
  title     = "Ingress Policy ${k}"
  ingress_from {
    dynamic "sources" {
      for_each = merge(
        { for k, v in lookup(lookup(each.value["from"], "sources", {}), "resources", []) : v => "resource" },
      { for k, v in lookup(lookup(each.value["from"], "sources", {}), "access_levels", []) : v => "access_level" })
      content {
        resource     = sources.value == "resource" ? sources.key : null
        access_level = sources.value == "access_level" ? sources.key != "*" ? "accessPolicies/${var.policy}/accessLevels/${sources.key}" : "*" : null
      }
    }
    identity_type = lookup(each.value["from"], "identity_type", null)
    identities    = lookup(each.value["from"], "identities", null)
  }

  ingress_to {
    resources = lookup(each.value["to"], "resources", ["*"])
    dynamic "operations" {
      for_each = lookup(each.value["to"], "operations", [])
      content {
        service_name = operations.key
        dynamic "method_selectors" {
          for_each = operations.key != "*" ? merge(
            { for v in lookup(operations.value, "methods", []) : v => "method" },
          { for v in lookup(operations.value, "permissions", []) : v => "permission" }) : {}
          content {
            method     = method_selectors.value == "method" ? method_selectors.key : null
            permission = method_selectors.value == "permission" ? method_selectors.key : null
          }
        }
      }
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_access_context_manager_service_perimeter_egress_policy" "egress_policies" {
  for_each = { for k, v in var.egress_policies : k => v }

  perimeter = google_access_context_manager_service_perimeter.regular_service_perimeter.name
  title     = "Egress Policy ${k}"

  egress_from {
    identity_type = lookup(each.value["from"], "identity_type", null)
    identities    = lookup(each.value["from"], "identities", null)
    dynamic "sources" {
      for_each = { for k, v in lookup(lookup(each.value["from"], "sources", {}), "access_levels", []) : v => "access_level" }
      content {
        access_level = sources.value == "access_level" ? sources.key != "*" ? "accessPolicies/${var.policy}/accessLevels/${sources.key}" : "*" : null
      }
    }
    source_restriction = lookup(each.value["from"], "sources", null) != null ? "SOURCE_RESTRICTION_ENABLED" : null
  }
  egress_to {
    resources          = lookup(each.value["to"], "resources", ["*"])
    external_resources = lookup(each.value["to"], "external_resources", [])
    dynamic "operations" {
      for_each = lookup(each.value["to"], "operations", [])
      content {
        service_name = operations.key
        dynamic "method_selectors" {
          for_each = operations.key != "*" ? merge(
            { for v in lookup(operations.value, "methods", []) : v => "method" },
          { for v in lookup(operations.value, "permissions", []) : v => "permission" }) : {}
          content {
            method     = method_selectors.value == "method" ? method_selectors.key : null
            permission = method_selectors.value == "permission" ? method_selectors.key : null
          }
        }
      }
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

############################################
#             DRY-RUN POLICIES             #
############################################

resource "google_access_context_manager_service_perimeter_dry_run_ingress_policy" "ingress_policies" {
  for_each = { for k, v in var.ingress_policies_dry_run : k => v }

  perimeter = google_access_context_manager_service_perimeter.regular_service_perimeter.name
  title     = "Ingress Policy ${k}"
  ingress_from {
    dynamic "sources" {
      for_each = merge(
        { for k, v in lookup(lookup(each.value["from"], "sources", {}), "resources", []) : v => "resource" },
      { for k, v in lookup(lookup(each.value["from"], "sources", {}), "access_levels", []) : v => "access_level" })
      content {
        resource     = sources.value == "resource" ? sources.key : null
        access_level = sources.value == "access_level" ? sources.key != "*" ? "accessPolicies/${var.policy}/accessLevels/${sources.key}" : "*" : null
      }
    }
    identity_type = lookup(each.value["from"], "identity_type", null)
    identities    = lookup(each.value["from"], "identities", null)
  }

  ingress_to {
    resources = lookup(each.value["to"], "resources", ["*"])
    dynamic "operations" {
      for_each = lookup(each.value["to"], "operations", [])
      content {
        service_name = operations.key
        dynamic "method_selectors" {
          for_each = operations.key != "*" ? merge(
            { for v in lookup(operations.value, "methods", []) : v => "method" },
          { for v in lookup(operations.value, "permissions", []) : v => "permission" }) : {}
          content {
            method     = method_selectors.value == "method" ? method_selectors.key : null
            permission = method_selectors.value == "permission" ? method_selectors.key : null
          }
        }
      }
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_access_context_manager_service_perimeter_dry_run_egress_policy" "egress_policies" {
  for_each = { for k, v in var.egress_policies_dry_run : k => v }

  perimeter = google_access_context_manager_service_perimeter.regular_service_perimeter.name
  title     = "Egress Policy ${k}"

  egress_from {
    identity_type = lookup(each.value["from"], "identity_type", null)
    identities    = lookup(each.value["from"], "identities", null)
    dynamic "sources" {
      for_each = { for k, v in lookup(lookup(each.value["from"], "sources", {}), "access_levels", []) : v => "access_level" }
      content {
        access_level = sources.value == "access_level" ? sources.key != "*" ? "accessPolicies/${var.policy}/accessLevels/${sources.key}" : "*" : null
      }
    }
    source_restriction = lookup(each.value["from"], "sources", null) != null ? "SOURCE_RESTRICTION_ENABLED" : null
  }
  egress_to {
    resources = lookup(each.value["to"], "resources", ["*"])
    dynamic "operations" {
      for_each = lookup(each.value["to"], "operations", [])
      content {
        service_name = operations.key
        dynamic "method_selectors" {
          for_each = operations.key != "*" ? merge(
            { for v in lookup(operations.value, "methods", []) : v => "method" },
          { for v in lookup(operations.value, "permissions", []) : v => "permission" }) : {}
          content {
            method     = method_selectors.value == "method" ? method_selectors.key : null
            permission = method_selectors.value == "permission" ? method_selectors.key : null
          }
        }
      }
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
