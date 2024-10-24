/**
 * Copyright 2022 Google LLC
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

module "project_one" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 17.0"

  name              = "vpcsc-test-one"
  random_project_id = true
  org_id            = var.parent_id
  billing_account   = var.billing_account
}

module "project_two" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 17.0"

  name              = "vpcsc-test-two"
  random_project_id = true
  org_id            = var.parent_id
  billing_account   = var.billing_account
}

module "project_three" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 17.0"

  name              = "vpcsc-test-two"
  random_project_id = true
  org_id            = var.parent_id
  billing_account   = var.billing_account
}
