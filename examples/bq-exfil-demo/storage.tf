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

module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
  version = "~> 8.0"

  dataset_id   = "project_1_dataset"
  dataset_name = "project_1_dataset"
  description  = "Some Cars"
  project_id   = module.project1.project_id
  location     = "US"
  tables = [
    {
      table_id = "cars",
      schema   = "fixtures/schema.json",
      time_partitioning = {
        type                     = "DAY",
        field                    = null,
        require_partition_filter = false,
        expiration_ms            = null,
      },
      range_partitioning = null,
      expiration_time    = null,
      clustering         = null,
      labels = {
        env = "dev"
      },
    }
  ]
  dataset_labels = {
    env = "dev"
  }
}

resource "null_resource" "load_data" {
  triggers = {
    bq_table = module.bigquery.table_names[0]
  }

  provisioner "local-exec" {
    command = <<EOF
      bq --project_id ${module.project1.project_id} \
      load \
      --location=US \
      --format=csv \
      --field_delimiter=';' \
      project_1_dataset.cars \
      gs://${google_storage_bucket.source_bucket.name}/${google_storage_bucket_object.data.output_name}
EOF
  }
}

resource "google_storage_bucket" "source_bucket" {
  project  = module.project1.project_id
  name     = "${module.project1.project_id}-source-bucket"
  location = "US"
}

resource "google_storage_bucket_object" "data" {
  name   = "cars.csv"
  source = "fixtures/cars.csv"
  bucket = google_storage_bucket.source_bucket.name
}


resource "google_storage_bucket" "target_bucket" {
  project  = module.project2.project_id
  name     = "${module.project2.project_id}-target-bucket"
  location = "US"
}
