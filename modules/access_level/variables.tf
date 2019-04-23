variable "name"{
    description = "Description of the AccessLevel and its use. Does not affect behavior."
}

variable "policy" {
  description = "(Required) Name of the parent policy"
}

variable "combining_function" {
  description = "How the conditions list should be combined to determine if a request is granted this AccessLevel. If AND is used, each Condition in conditions must be satisfied for the AccessLevel to be applied. If OR is used, at least one Condition in conditions must be satisfied for the AccessLevel to be applied. Defaults to AND if unspecified."
  default = "AND"
}
variable "conditions" {
    description = "A set of requirements for the AccessLevel to be granted."
    type = "map"
    default = {}
}

variable "description" {
  description = "Description of the access level"
  default =   ""
}


variable "ip_subnetworks"  {
    type = "list"
    default = [""]
}

variable "required_access_levels"  {
    type = "list"
    default = [""]
}

variable "members"  {
    type = "list"
    default = [""]
}

variable "negate"  {
    default = "false"
}

variable "enable_device_policy"  {
    default = "false"
}

variable "require_screen_lock"  {
    default = "false"
}

variable "allowed_encryption_statuses"  {
    type = "list"
    default = [""]
}

variable "allowed_device_management_levels"  {
    type = "list"
    default = [""]
}

variable "os_constraints" {
  description = "some description"
  type = "map"
  default = {}
}