resource "google_access_context_manager_access_policy" "access-policy" {
  provider = "google-beta"
  parent   = "organizations/${var.parent_id}"
  title    = "${var.policy_name}"
}
