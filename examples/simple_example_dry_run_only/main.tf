/**
 * Copyright 2026 Google LLC
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

module "access_context_manager_policy" {
  source  = "terraform-google-modules/vpc-service-controls/google"
  version = "~> 8.0"

  parent_id   = var.parent_id
  policy_name = var.policy_name
  scopes      = var.scopes
}

# A perimeter staged in dry-run mode only: every enforced input is left at its
# default (empty), and configuration is supplied exclusively through the
# `_dry_run` inputs. This is the supported way to stage a perimeter and observe
# its violations before turning enforcement on.
#
# No existing example covers this shape -- every other one populates the
# enforced side as well -- which is why the non-convergence it triggers went
# unnoticed.
module "regular_service_perimeter_dry_run_only" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version = "~> 8.0"

  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = "regular_perimeter_dry_run_only"
  description    = "Perimeter staged in dry-run mode with no enforced configuration"

  # Enforced side deliberately untouched. `vpc_accessible_services` is left at
  # its ["*"] default, which means "no restriction" -- so nothing here asks the
  # module for an enforced configuration.

  resources_dry_run           = [var.protected_project_number]
  restricted_services_dry_run = ["storage.googleapis.com"]
}
