output "policy_id" {
  description = "Resource name of the AccessPolicy."
  value       = "${google_access_context_manager_access_policy.access-policy.name}"
}

output "policy_name" {
  description = "The policy's name."
  value       = "${var.policy_name}"
}
