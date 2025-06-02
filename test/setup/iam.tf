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
  int_required_project_roles = [
    "roles/owner",
  ]

  int_required_org_roles = [
    "roles/resourcemanager.organizationViewer",
    "roles/accesscontextmanager.policyAdmin",
    "roles/iam.securityAdmin",
  ]

  policy_sa_required_org_role = "roles/resourcemanager.organizationViewer"

}

resource "google_service_account" "int_test" {
  project      = module.project-vpc-service-controls.project_id
  account_id   = "vpc-sc-ci-testsi-${random_id.random_suffix.hex}"
  display_name = "vpc-service-controls-ci-tests"
}

resource "google_project_iam_member" "int_test" {
  count = length(local.int_required_project_roles)

  project = module.project-vpc-service-controls.project_id
  role    = local.int_required_project_roles[count.index]
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_project_iam_member" "bq_roles_0" {
  project = module.project-vpc-service-controls-policy-0.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_project_iam_member" "bq_roles_1" {
  project = module.project-vpc-service-controls-policy-1.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_project_iam_member" "storage_roles_0" {
  project = module.project-vpc-service-controls-policy-0.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_project_iam_member" "storage_roles_1" {
  project = module.project-vpc-service-controls-policy-1.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_service_account_key" "int_test" {
  service_account_id = google_service_account.int_test.id
}

resource "google_organization_iam_member" "int_test_org" {
  count = length(local.int_required_org_roles)

  org_id = var.org_id
  role   = local.int_required_org_roles[count.index]
  member = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_organization_iam_member" "policy_sa_org" {
  count = length(google_service_account.test_policy)

  org_id = var.org_id
  role   = local.policy_sa_required_org_role
  member = "serviceAccount:${google_service_account.test_policy[count.index].email}"
}

resource "google_service_account" "test_policy" {
  count = 2

  project      = module.project-vpc-service-controls.project_id
  account_id   = "test-vpc-sc-policy-${random_id.random_suffix.hex}-${count.index}"
  display_name = "test-vpc-sc-policy-${count.index}"
}

