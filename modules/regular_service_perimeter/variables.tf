variable "policy" {
  description = "(Required) Name of the parent policy"
}

variable "description" {
  description = "Description of the regular perimeter"
}

variable "perimeter_name" {
  description = "Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores"
}

variable "restricted_services" {
  # description = "(Optional) GCP services that are subject to the Service Perimeter restrictions. May contain a list of services or a single wildcard "". For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions. Wildcard means that unless explicitly specified by 'unrestrictedServices' list, any service is treated as restricted. One of the fields 'restrictedServices', 'unrestrictedServices' must contain a wildcard '', otherwise the Service Perimeter specification is invalid. It also means that both field being empty is invalid as well. 'restrictedServices' can be empty if and only if 'unrestrictedServices' list contains a '*' wildcard."
  type    = "list"
  default = [""]
}

variable "unrestricted_services" {
  #description = " ](Optional) GCP services that are not subject to the Service Perimeter restrictions. May contain a list of services or a single wildcard "". For example, if logging.googleapis.com is unrestricted, users can access logs inside the perimeter as if the perimeter doesn't exist, and it also means VMs inside the perimeter can access logs outside the perimeter. The wildcard means that unless explicitly specified by "restrictedServices" list, any service is treated as unrestricted. One of the fields "restrictedServices", "unrestrictedServices" must contain a wildcard "", otherwise the Service Perimeter specification is invalid. It also means that both field being empty is invalid as well. "unrestrictedServices" can be empty if and only if "restrictedServices" list contains a "*" wildcard."
  type    = "list"
  default = ["*"]
}

variable "resources" {
  description = "(Optional) A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = "list"
  default     = [""]
}

variable "access_levels" {
  description = "(Optional) A list of AccessLevel resource names that allow resources within the ServicePerimeter to be accessed from the internet. AccessLevels listed must be in the same policy as this ServicePerimeter. Referencing a nonexistent AccessLevel is a syntax error. If no AccessLevel names are listed, resources within the perimeter can only be accessed via GCP calls with request origins within the perimeter. "
  default     = [""]
}

variable "shared_resources" {
  description = "(Optional) A map of lists of resources to share in a Bridge perimeter module. Each list should contain all or a subset of the perimeters resources"
  default     = {}
}
