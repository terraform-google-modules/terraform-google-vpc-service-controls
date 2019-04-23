locals {
  #device_policy_map = "${var.conditions["device_policy"]}"
  #device_policy_list = ["${var.conditions["device_policy"]}"]
}
resource "google_access_context_manager_access_level" "access-level" {
  provider       = "google-beta"
  parent         = "accessPolicies/${var.policy}"
  name        = "accessPolicies/${var.policy}/accessLevels/${var.name}"
  title       = "${var.name}"
  description = "${var.description}"
  basic  = [
    {
      conditions = [{
        ip_subnetworks = ["${var.ip_subnetworks}"]
        required_access_levels = "${var.required_access_levels}"
        members = "${var.members}"
        negate = "${var.negate}"
        device_policy  {
          require_screen_lock = "${var.require_screen_lock}"
          allowed_encryption_statuses = "${var.allowed_encryption_statuses}"
          allowed_device_management_levels = "${var.allowed_device_management_levels}"
          os_constraints = [{
             minimum_version = "${lookup(var.os_constraints, "minimum_version", "")}"
             os_type = "${lookup(var.os_constraints, "os_type", "")}"
          }]
         }
      }]

      combining_function = "${var.combining_function}"
  }]
}