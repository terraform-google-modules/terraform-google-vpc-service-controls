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
  ingress_policies_dry_run = [
    {
      title = "dry-run"
      from = {
        identities = var.read_bucket_identities
        sources = {
          access_levels = [module.access_level_members_dry_run.name]
        },
      }
      to = {
        resources = [
          "*"
        ]
        operations = {
          "storage.googleapis.com" = {
            methods = [
              "google.storage.objects.get",
              "google.storage.objects.list"
            ]
          }
        }
      }
    }
  ]
}

module "access_context_manager_policy" {
  source  = "terraform-google-modules/vpc-service-controls/google"
  version = "~> 7.1"

  parent_id   = var.parent_id
  policy_name = var.policy_name
  scopes      = var.scopes

  depends_on = [module.gcs_buckets]
}

module "access_level_members" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 7.1"

  description = "Simple Example Access Level"
  policy      = module.access_context_manager_policy.policy_id
  name        = var.access_level_name
  members     = var.members
  regions     = var.regions
}

module "access_level_members_dry_run" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 7.1"

  description = "Simple Example Access Level dry-run"
  policy      = module.access_context_manager_policy.policy_id
  name        = var.access_level_name_dry_run
  members     = var.members
  regions     = var.regions
}

resource "time_sleep" "wait_for_members" {
  create_duration  = "90s"
  destroy_duration = "90s"

  depends_on = [
    module.access_level_members,
    module.access_level_members_dry_run
  ]
}

module "regular_service_perimeter_1" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version = "~> 7.1"

  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = var.perimeter_name

  description           = "Perimeter shielding bigquery project"
  resources             = [var.protected_project_ids["number"]]
  resources_dry_run     = [var.protected_project_ids["number"]]
  access_levels         = [module.access_level_members.name]
  access_levels_dry_run = [module.access_level_members_dry_run.name]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  ingress_policies = [
    {
      title = "Allow Access from everywhere"
      from = {
        identities = var.read_bucket_identities
        sources = {
          access_levels = ["*"] # Allow Access from everywhere
        },
      }
      to = {
        resources = [
          "*"
        ]
        operations = {
          "storage.googleapis.com" = {
            methods = [
              "google.storage.objects.get",
              "google.storage.objects.list"
            ]
          }
        }
      }
    },
    {
      title = "Allow Access from project"
      from = {
        sources = {
          resources = ["projects/${var.public_project_ids["number"]}"] # Allow Access from project
        },
        identity_type = "ANY_SERVICE_ACCOUNT"

      }
      to = {
        resources = [
          "*"
        ]
        operations = {
          "storage.googleapis.com" = {
            methods = [
              "google.storage.objects.get",
              "google.storage.objects.list"
            ]
          }
        }
      }
    },
    {
      title = "from bucket read identity"
      from = {
        identities = var.read_bucket_identities
        source = {
          resources = ["projects/${var.public_project_ids["number"]}"]
        }
      }
      to = {
        resources = [
          "projects/${var.protected_project_ids["number"]}"
        ]
        operations = {
          "storage.googleapis.com" = {
            methods = [
              "google.storage.objects.get",
              "google.storage.objects.list"
            ]
          }
        }
      }
    }
  ]

  ingress_policies_dry_run      = distinct(tolist(local.ingress_policies_dry_run))
  ingress_policies_keys_dry_run = ["rule_one"]


  shared_resources = {
    all = [var.protected_project_ids["number"]]
  }

  depends_on = [
    module.gcs_buckets,
    time_sleep.wait_for_members
  ]
}

module "gcs_buckets" {
  source           = "terraform-google-modules/cloud-storage/google"
  version          = "~> 11.0"
  project_id       = var.public_project_ids["id"]
  names            = var.buckets_names
  randomize_suffix = true
  prefix           = var.buckets_prefix
  set_admin_roles  = true
  admins           = var.members
}
