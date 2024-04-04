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

    dynamic "ingress_policies" {
      for_each = var.ingress_policies
      iterator = ingress_policies
      content {
        ingress_from {
          dynamic "sources" {
            for_each = merge(
              { for k, v in lookup(ingress_policies.value["from"]["sources"], "resources", []) : v => "resource" },
            { for k, v in lookup(ingress_policies.value["from"]["sources"], "access_levels", []) : v => "access_level" })
            content {
              resource     = sources.value == "resource" ? sources.key : null
              access_level = sources.value == "access_level" ? sources.key != "*" ? "accessPolicies/${var.policy}/accessLevels/${sources.key}" : "*" : null
            }
          }
          identity_type = lookup(ingress_policies.value["from"], "identity_type", null)
          identities    = lookup(ingress_policies.value["from"], "identities", null)
        }

        ingress_to {
          resources = lookup(ingress_policies.value["to"], "resources", ["*"])
          dynamic "operations" {
            for_each = ingress_policies.value["to"]["operations"]
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
      }
    }
    dynamic "egress_policies" {
      for_each = var.egress_policies
      iterator = egress_policies
      content {
        egress_from {
          identity_type = lookup(egress_policies.value["from"], "identity_type", null)
          identities    = lookup(egress_policies.value["from"], "identities", null)
          dynamic "sources" {
            for_each = { for k, v in lookup(egress_policies.value["from"]["sources"], "access_levels", []) : v => "access_level" }
            content {
              access_level = sources.value == "access_level" ? sources.key != "*" ? "accessPolicies/${var.policy}/accessLevels/${sources.key}" : "*" : null
            }
          }
          source_restriction = egress_policies.value["from"]["sources"] != null ? "SOURCE_RESTRICTION_ENABLED" : null
        }
        egress_to {
          resources = lookup(egress_policies.value["to"], "resources", ["*"])
          dynamic "operations" {
            for_each = lookup(egress_policies.value["to"], "operations", [])
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
      }
    }

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

      dynamic "ingress_policies" {
        for_each = var.ingress_policies_dry_run
        iterator = ingress_policies_dry_run
        content {
          ingress_from {
            dynamic "sources" {
              for_each = merge(
                { for k, v in lookup(ingress_policies_dry_run.value["from"]["sources"], "resources", []) : v => "resource" },
              { for k, v in lookup(ingress_policies_dry_run.value["from"]["sources"], "access_levels", []) : v => "access_level" })
              content {
                resource     = sources.value == "resource" ? sources.key : null
                access_level = sources.value == "access_level" ? sources.key != "*" ? "accessPolicies/${var.policy}/accessLevels/${sources.key}" : "*" : null
              }
            }
            identity_type = lookup(ingress_policies_dry_run.value["from"], "identity_type", null)
            identities    = lookup(ingress_policies_dry_run.value["from"], "identities", null)
          }

          ingress_to {
            resources = lookup(ingress_policies_dry_run.value["to"], "resources", ["*"])
            dynamic "operations" {
              for_each = ingress_policies_dry_run.value["to"]["operations"]
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
        }
      }
      dynamic "egress_policies" {
        for_each = var.egress_policies_dry_run
        iterator = egress_policies_dry_run
        content {
          egress_from {
            identity_type = lookup(egress_policies_dry_run.value["from"], "identity_type", null)
            identities    = lookup(egress_policies_dry_run.value["from"], "identities", null)
            dynamic "sources" {
              for_each = { for k, v in lookup(egress_policies_dry_run.value["from"]["sources"], "access_levels", []) : v => "access_level" }
              content {
                access_level = sources.value == "access_level" ? sources.key != "*" ? "accessPolicies/${var.policy}/accessLevels/${sources.key}" : "*" : null
              }
            }
            source_restriction = egress_policies_dry_run.value["from"]["sources"] != null ? "SOURCE_RESTRICTION_ENABLED" : null
          }
          egress_to {
            resources = lookup(egress_policies_dry_run.value["to"], "resources", ["*"])
            dynamic "operations" {
              for_each = lookup(egress_policies_dry_run.value["to"], "operations", [])
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
        }
      }

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
    ignore_changes = [status[0].resources]
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
