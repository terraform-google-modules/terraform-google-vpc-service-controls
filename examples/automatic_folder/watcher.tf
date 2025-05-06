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

module "event_folder_log_entry" {
  source  = "terraform-google-modules/event-function/google//modules/event-folder-log-entry"
  version = "~> 5.0"

  filter     = <<EOF
resource.type="project" AND
protoPayload.serviceName="cloudresourcemanager.googleapis.com" AND
(protoPayload.methodName="CreateProject" OR protoPayload.methodName="DeleteProject" OR protoPayload.methodName="UpdateProject")
EOF
  name       = local.watcher_name
  project_id = var.project_id
  folder_id  = var.folder_id
}

resource "google_service_account" "watcher" {
  project = var.project_id

  account_id   = local.watcher_name
  display_name = local.watcher_name
}

module "localhost_function" {
  source  = "terraform-google-modules/event-function/google"
  version = "~> 5.0"

  description = "Adds projects to VPC service permiterer."
  entry_point = "handler"

  environment_variables = {
    FOLDER_ID = var.folder_id
  }

  event_trigger    = module.event_folder_log_entry.function_event_trigger
  name             = local.watcher_name
  project_id       = var.project_id
  region           = var.region
  source_directory = abspath(path.module)
  runtime          = "python37"
  //  runtime               = "go111"
  available_memory_mb   = 2048
  timeout_s             = 540
  service_account_email = google_service_account.watcher.email
}
