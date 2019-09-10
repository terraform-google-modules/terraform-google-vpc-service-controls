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

provider "archive" {
  version = "~> 1.0"
}

provider "random" {
  version = "~> 2.0"
}

provider "null" {
  version = "~> 2.1"
}

data "google_projects" "in_perimeter_folder" {
  filter = "parent.id:${var.folder_id}"
}

data "google_project" "in_perimeter_folder" {
  count = length(data.google_projects.in_perimeter_folder.projects)

  project_id = data.google_projects.in_perimeter_folder.projects[count.index].project_id
}

locals {
  projects = compact(data.google_project.in_perimeter_folder.*.number)
}

module "access_context_manager_policy" {
  source  = "terraform-google-modules/vpc-service-controls/google"
  version = "1.0.0"

  parent_id   = var.parent_id
  policy_name = var.policy_name
}

module "access_level_members" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "1.0.0"

  description = "${var.perimeter_name} Access Level"
  policy      = module.access_context_manager_policy.policy_id
  name        = "${var.perimeter_name}_members"
  members     = var.members
}

module "service_perimeter" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version = "1.0.0"

  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = var.perimeter_name

  description = "Perimeter ${var.perimeter_name}"
  resources   = local.projects

  access_levels       = [module.access_level_members.name]
  restricted_services = var.restricted_services

  shared_resources = {
    all = local.projects
  }
}
