/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "policy" {
  description = "Name of the parent policy"
  type        = string
}

variable "description" {
  description = "Description of the regular perimeter"
  type        = string
}

variable "perimeter_name" {
  description = "Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores"
  type        = string
}

variable "restricted_services" {
  description = "GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage bu[...]"
  type        = list(string)
  default     = []
}

variable "resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects and VPC networks are allowed."
  type        = list(string)
  default     = []
}

variable "resource_keys" {
  description = "A list of keys to use for the Terraform state. The order should correspond to var.resources and the keys must not be dynamically computed. If `null`, var.resources will be used as[...]"
  type        = list(string)
  default     = null
}

variable "access_levels" {
  description = "A list of AccessLevel resource names that allow resources within the ServicePerimeter to be accessed from the internet. AccessLevels listed must be in the same policy as this Serv[...]"
  type        = list(string)
  default     = []
}

variable "restricted_services_dry_run" {
  description = "(Dry-run) GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the [...]"
  type        = list(string)
  default     = []
}

variable "resources_dry_run" {
  description = "(Dry-run) A list of GCP resources that are inside of the service perimeter. Currently only projects and VPC networks are allowed. If set, a dry-run policy will be set."
  type        = list(string)
  default     = []
}

variable "resource_keys_dry_run" {
  description = "(Dry-run) A list of keys to use for the Terraform state. The order should correspond to var.resources_dry_run and the keys must not be dynamically computed. If `null`, var.resourc[...]"
  type        = list(string)
  default     = null
}

variable "ingress_policies_keys" {
  description = "A list of keys to use for the Terraform state. The order should correspond to var.ingress_policies and the keys must not be dynamically computed. If `null`, var.ingress_policies w[...]"
  type        = list(string)
  default     = null
}

variable "egress_policies_keys" {
  description = "A list of keys to use for the Terraform state. The order should correspond to var.egress_policies and the keys must not be dynamically computed. If `null`, var.egress_policies wil[...]"
  type        = list(string)
  default     = null
}

variable "ingress_policies_keys_dry_run" {
  description = "(Dry-run) A list of keys to use for the Terraform state. The order should correspond to var.ingress_policies_dry_run and the keys must not be dynamically computed. If `null`, var.[...]"
  type        = list(string)
  default     = null
}

variable "egress_policies_keys_dry_run" {
  description = "(Dry-run) A list of keys to use for the Terraform state. The order should correspond to var.egress_policies_dry_run and the keys must not be dynamically computed. If `null`, var.e[...]"
  type        = list(string)
  default     = null
}

variable "access_levels_dry_run" {
  description = "(Dry-run) A list of AccessLevel resource names that allow resources within the ServicePerimeter to be accessed from the internet. AccessLevels listed must be in the same policy as[...]"
  type        = list(string)
  default     = []
}

variable "shared_resources" {
  description = "A map of lists of resources to share in a Bridge perimeter module. Each list should contain all or a subset of the perimeters resources"
  type        = object({ all = list(string) })
  default     = { all = [] }
}

variable "egress_policies" {
  description = "A list of all [egress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#egress-rules-reference), each list object has a `from` and `to` value that[...]"
  type = list(object({
    title = optional(string, null)
    from = object({
      sources = optional(object({
        resources     = optional(list(string), [])
        access_levels = optional(list(string), [])
      }), {}),
      identity_type = optional(string, null)
      identities    = optional(list(string), null)
      source_restriction = optional(string, null)
    })
    to = object({
      operations = optional(map(object({
        methods     = optional(list(string), [])
        permissions = optional(list(string), [])
      })), {}),
      roles              = optional(list(string), null)
      resources          = optional(list(string), ["*"])
      external_resources = optional(list(string), [])
    })
  }))
  default = []
}

variable "ingress_policies" {
  description = "A list of all [ingress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#ingress-rules-reference), each list object has a `from` and `to` value th[...]"
  type = list(object({
    title = optional(string, null)
    from = object({
      sources = optional(object({
        resources     = optional(list(string), [])
        access_levels = optional(list(string), [])
      }), {}),
      identity_type = optional(string, null)
      identities    = optional(list(string), null)
      source_restriction = optional(string, null)
    })
    to = object({
      operations = optional(map(object({
        methods     = optional(list(string), [])
        permissions = optional(list(string), [])
      })), {}),
      roles     = optional(list(string), null)
      resources = optional(list(string), ["*"])
    })
  }))
  default = []
}

variable "egress_policies_dry_run" {
  description = "A list of all [egress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#egress-rules-reference), each list object has a `from` and `to` value that[...]"
  type = list(object({
    title = optional(string, null)
    from = object({
      sources = optional(object({
        resources     = optional(list(string), [])
        access_levels = optional(list(string), [])
      }), {}),
      identity_type = optional(string, null)
      identities    = optional(list(string), null)
    })
    to = object({
      operations = optional(map(object({
        methods     = optional(list(string), [])
        permissions = optional(list(string), [])
      })), {}),
      roles              = optional(list(string), null)
      resources          = optional(list(string), ["*"])
      external_resources = optional(list(string), [])
    })
  }))
  default = []
}

variable "ingress_policies_dry_run" {
  description = "A list of all [ingress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#ingress-rules-reference), each list object has a `from` and `to` value th[...]"
  type = list(object({
    title = optional(string, null)
    from = object({
      sources = optional(object({
        resources     = optional(list(string), [])
        access_levels = optional(list(string), [])
      }), {}),
      identity_type = optional(string, null)
      identities    = optional(list(string), null)
    })
    to = object({
      operations = optional(map(object({
        methods     = optional(list(string), [])
        permissions = optional(list(string), [])
      })), {}),
      roles     = optional(list(string), null)
      resources = optional(list(string), ["*"])
    })
  }))
  default = []
}

variable "vpc_accessible_services" {
  description = "A list of [VPC Accessible Services](https://cloud.google.com/vpc-service-controls/docs/vpc-accessible-services) that will be restricted within the VPC Network. Use [\"*\"] to all[...]"
  type        = list(string)
  default     = ["*"]
}

variable "vpc_accessible_services_dry_run" {
  description = "(Dry-run) A list of [VPC Accessible Services](https://cloud.google.com/vpc-service-controls/docs/vpc-accessible-services) that will be restricted within the VPC Network. Use [\"*[...]"
  type        = list(string)
  default     = ["*"]
}