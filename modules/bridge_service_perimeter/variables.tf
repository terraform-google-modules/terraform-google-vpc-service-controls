variable "policy" {
  description = "(Required) Name of the parent policy"
}

variable "description" {
  description = "Description of the bridge perimeter"
}

variable "perimeter_name" {
  description = "Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores"
}

variable "resources" {
  description = "(Optional) A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = "list"
  default     = [""]
}