# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module "logging" {
  source = "./modules/logging"

  org_id                          = var.org_id
  project_id                      = var.project_id
  log_bucket_name                 = var.log_bucket_name
  log_based_metric_name           = var.log_based_metric_name
  log_router_aggregated_sink_name = var.log_router_aggregated_sink_name
}

module "dashboard" {
  count = var.add_dashboard ? 1 : 0

  source     = "./modules/dashboard"
  depends_on = [module.logging]

  project_id            = var.project_id
  log_based_metric_name = var.log_based_metric_name
}

module "alerting" {
  count = var.add_alerting_example ? 1 : 0

  source     = "./modules/alerting"
  depends_on = [module.logging]

  project_id            = var.project_id
  email_address         = var.email_address
  log_based_metric_name = var.log_based_metric_name
}
