resource "google_access_context_manager_service_perimeter" "service-perimeter" {
  provider       = "google-beta"
  parent         = "accessPolicies/${var.policy}"
  perimeter_type = "PERIMETER_TYPE_REGULAR"
  name           = "accessPolicies/${var.policy}/servicePerimeters/${var.perimeter_name}"
  title          = "${var.perimeter_name}"

  status {
    restricted_services   = "${var.restricted_services}"
    unrestricted_services = "${var.unrestricted_services}"
    resources             = "${formatlist("projects/%s", var.resources)}"
    access_levels         = "${var.access_levels}"
  }
}
