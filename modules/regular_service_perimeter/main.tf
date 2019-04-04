resource "google_access_context_manager_service_perimeter" "service-perimeter" {
  parent      = "accessPolicies/${var.policy}"
  name        = "accessPolicies/${var.policy}/servicePerimeters/${var.perimeter_name}"
  title       = "${var.perimeter_name}"
  status {
    restricted_services = "${var.restricted_services}"
    unrestricted_services = "${var.unrestricted_services}"
    resources = "${var.resources}"
    access_levels = "${var.access_levels}"

  }
}