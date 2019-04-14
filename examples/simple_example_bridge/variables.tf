variable "parent_id" {
  description = "(Required) The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent."
}

variable "policy_name" {
  description = "The policy's name."
}
