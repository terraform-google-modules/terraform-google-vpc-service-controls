output "target_bucket" {
  value = google_storage_bucket.target_bucket.url
}

output "source_project" {
  value = module.project1.project_id
}
