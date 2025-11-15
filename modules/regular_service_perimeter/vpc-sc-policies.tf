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



locals {
  # enforced
  # ingress_rules
  ingress_policies_keys = var.ingress_policies_keys != null ? var.ingress_policies_keys : [for k, v in var.ingress_policies : tostring(k)]
  ingress_policies = {
    for ipk in local.ingress_policies_keys :
    ipk => var.ingress_policies[index(local.ingress_policies_keys, ipk)]
  }

  # egress_rules
  egress_policies_keys = var.egress_policies_keys != null ? var.egress_policies_keys : [for k, v in var.egress_policies : tostring(k)]
  egress_policies = {
    for epk in local.egress_policies_keys :
    epk => var.egress_policies[index(local.egress_policies_keys, epk)]
  }

  # dry-run
  # ingress_rules
  ingress_policies_keys_dry_run = var.ingress_policies_keys_dry_run != null ? var.ingress_policies_keys_dry_run : [for k, v in var.ingress_policies_dry_run : tostring(k)]
  ingress_policies_dry_run = {
    for ipk in local.ingress_policies_keys_dry_run :
    ipk => var.ingress_policies_dry_run[index(local.ingress_policies_keys_dry_run, ipk)]
  }

  # egress_rules
  egress_policies_keys_dry_run = var.egress_policies_keys_dry_run != null ? var.egress_policies_keys_dry_run : [for k, v in var.egress_policies_dry_run : tostring(k)]
  egress_policies_dry_run = {
    for epk in local.egress_policies_keys_dry_run :
    epk => var.egress_policies_dry_run[index(local.egress_policies_keys_dry_run, epk)]
  }
}

resource "google_access_context_manager_service_perimeter_ingress_policy" "ingress_policies" {
  for_each = local.ingress_policies

  perimeter = google_access_context_manager_service_perimeter.regular_service_perimeter.name
  title     = coalesce(each.value["title"], "Ingress Policy ${each.key}")
  ingress_from {
    dynamic "sources" {
      for_each = merge(
        { for k, v in each.value["from"]["sources"]["resources"] : v => "resource" },
        { for k, v in each.value["from"]["sources"]["access_levels"] : v => "access_level" }
      )
      content {
        resource     = sources.value == "resource" ? sources.key : null
        access_level = sources.value == "access_level" ? sources.key != "*" ? "accessPolicies/${var.policy}/accessLevels/${sources.key}" : "*" : null
      }
    }
    identity_type = each.value["from"]["identity_type"]
    identities    = each.value["from"]["identities"]
  }

  ingress_to {
    resources = each.value["to"]["resources"]
    dynamic "operations" {
      for_each = each.value["to"]["operations"]
      content {
        service_name = operations.key
        dynamic "method_selectors" {
          for_each = operations.key != "*" ? merge(
            { for v in operations.value["methods"] : v => "method" },
            { for v in operations.value["permissions"] : v => "permission" }
          ) : {}
          content {
            method     = method_selectors.value == "method" ? method_selectors.key : null
            permission = method_selectors.value == "permission" ? method_selectors.key : null
          }
        }
      }
    }
  }

  depends_on = [google_access_context_manager_service_perimeter_resource.service_perimeter_resource]
}

resource "google_access_context_manager_service_perimeter_egress_policy" "egress_policies" {
  for_each = local.egress_policies

  perimeter = google_access_context_manager_service_perimeter.regular_service_perimeter.name
  title     = coalesce(each.value["title"], "Egress Policy ${each.key}")

  egress_from {
    identity_type = each.value["from"]["identity_type"]
    identities    = each.value["from"]["identities"]
    dynamic "sources" {
      for_each = merge(
        { for k, v in each.value["from"]["sources"]["resources"] : v => "resource" },
        { for k, v in each.value["from"]["sources"]["access_levels"] : v => "access_level" }
      )
      content {
        resource     = sources.value == "resource" ? sources.key : null
        access_level = sources.value == "access_level" ? sources.key != "*" ? "accessPolicies/${var.policy}/accessLevels/${sources.key}" : "*" : null
      }
    }
    source_restriction = each.value["from"]["sources"] != {} ? "SOURCE_RESTRICTION_ENABLED" : null
  }
  egress_to {
    resources          = each.value["to"]["resources"]
    external_resources = each.value["to"]["external_resources"]
    dynamic "operations" {
      for_each = each.value["to"]["operations"]
      content {
        service_name = operations.key
        dynamic "method_selectors" {
          for_each = operations.key != "*" ? merge(
            { for v in operations.value["methods"] : v => "method" },
            { for v in operations.value["permissions"] : v => "permission" }
          ) : {}
          content {
            method     = method_selectors.value == "method" ? method_selectors.key : null
            permission = method_selectors.value == "permission" ? method_selectors.key : null
          }
        }
      }
    }
  }
}

############################################
#             DRY-RUN POLICIES             #
############################################

resource "google_access_context_manager_service_perimeter_dry_run_ingress_policy" "ingress_policies" {
  for_each = local.ingress_policies_dry_run

  perimeter = google_access_context_manager_service_perimeter.regular_service_perimeter.name
  title     = coalesce(each.value["title"], "Ingress Policy ${each.key}")
  ingress_from {
    dynamic "sources" {
      for_each = merge(
        { for k, v in each.value["from"]["sources"]["resources"] : v => "resource" },
        { for k, v in each.value["from"]["sources"]["access_levels"] : v => "access_level" }
      )
      content {
        resource     = sources.value == "resource" ? sources.key : null
        access_level = sources.value == "access_level" ? sources.key != "*" ? "accessPolicies/${var.policy}/accessLevels/${sources.key}" : "*" : null
      }
    }
    identity_type = each.value["from"]["identity_type"]
    identities    = each.value["from"]["identities"]
  }

  ingress_to {
    resources = each.value["to"]["resources"]
    dynamic "operations" {
      for_each = each.value["to"]["operations"]
      content {
        service_name = operations.key
        dynamic "method_selectors" {
          for_each = operations.key != "*" ? merge(
            { for v in operations.value["methods"] : v => "method" },
            { for v in operations.value["permissions"] : v => "permission" }
          ) : {}
          content {
            method     = method_selectors.value == "method" ? method_selectors.key : null
            permission = method_selectors.value == "permission" ? method_selectors.key : null
          }
        }
      }
    }
  }

  depends_on = [google_access_context_manager_service_perimeter_dry_run_resource.dry_run_service_perimeter_resource]
}

resource "google_access_context_manager_service_perimeter_dry_run_egress_policy" "egress_policies" {
  for_each = local.egress_policies_dry_run

  perimeter = google_access_context_manager_service_perimeter.regular_service_perimeter.name
  title     = coalesce(each.value["title"], "Egress Policy ${each.key}")

  egress_from {
    identity_type = each.value["from"]["identity_type"]
    identities    = each.value["from"]["identities"]
    dynamic "sources" {
      for_each = merge(
        { for k, v in each.value["from"]["sources"]["resources"] : v => "resource" },
        { for k, v in each.value["from"]["sources"]["access_levels"] : v => "access_level" }
      )
      content {
        resource     = sources.value == "resource" ? sources.key : null
        access_level = sources.value == "access_level" ? sources.key != "*" ? "accessPolicies/${var.policy}/accessLevels/${sources.key}" : "*" : null
      }
    }
    source_restriction = each.value["from"]["sources"] != {} ? "SOURCE_RESTRICTION_ENABLED" : null
  }
  egress_to {
    resources          = each.value["to"]["resources"]
    external_resources = each.value["to"]["external_resources"]
    dynamic "operations" {
      for_each = each.value["to"]["operations"]
      content {
        service_name = operations.key
        dynamic "method_selectors" {
          for_each = operations.key != "*" ? merge(
            { for v in operations.value["methods"] : v => "method" },
            { for v in operations.value["permissions"] : v => "permission" }
          ) : {}
          content {
            method     = method_selectors.value == "method" ? method_selectors.key : null
            permission = method_selectors.value == "permission" ? method_selectors.key : null
          }
        }
      }
    }
  }
}
