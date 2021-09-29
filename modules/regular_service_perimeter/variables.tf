/**
 * Copyright 2019 Google LLC
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
}

variable "restricted_services" {
  description = "GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions."
  type        = list(string)
  default     = []
}

variable "resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
  default     = []
}

variable "access_levels" {
  description = "A list of AccessLevel resource names that allow resources within the ServicePerimeter to be accessed from the internet. AccessLevels listed must be in the same policy as this ServicePerimeter. Referencing a nonexistent AccessLevel is a syntax error. If no AccessLevel names are listed, resources within the perimeter can only be accessed via GCP calls with request origins within the perimeter. Example: 'accessPolicies/MY_POLICY/accessLevels/MY_LEVEL'. For Service Perimeter Bridge, must be empty."
  type        = list(string)
  default     = []
}

variable "restricted_services_dry_run" {
  description = "(Dry-run) GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions.  If set, a dry-run policy will be set."
  type        = list(string)
  default     = []
}

variable "resources_dry_run" {
  description = "(Dry-run) A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. If set, a dry-run policy will be set."
  type        = list(string)
  default     = []
}

variable "access_levels_dry_run" {
  description = "(Dry-run) A list of AccessLevel resource names that allow resources within the ServicePerimeter to be accessed from the internet. AccessLevels listed must be in the same policy as this ServicePerimeter. Referencing a nonexistent AccessLevel is a syntax error. If no AccessLevel names are listed, resources within the perimeter can only be accessed via GCP calls with request origins within the perimeter. Example: 'accessPolicies/MY_POLICY/accessLevels/MY_LEVEL'. For Service Perimeter Bridge, must be empty. If set, a dry-run policy will be set."
  type        = list(string)
  default     = []
}

variable "shared_resources" {
  description = "A map of lists of resources to share in a Bridge perimeter module. Each list should contain all or a subset of the perimeters resources"
  type        = object({ all = list(string) })
  default     = { all = [] }
}


## Have to solve it like this don't want use optional flag because is still experimental
variable "egress_policies" {
  description = "A list of all [egress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#egress-rules-reference), each list object has a `from` and `to` value that describes egress_from and egress_to."
  type = list(object({
    from = any
    to   = any
  }))
  default = []
}

## Have to solve it like this don't want use optional flag because is still experimental
variable "ingress_policies" {
  description = "A list of all [ingress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#ingress-rules-reference), each list object has a `from` and `to` value that describes ingress_from and ingress_to."
  type = list(object({
    from = any
    to   = any
  }))
  default = []
}


## Have to solve it like this don't want use optional flag because is still experimental
variable "egress_policies_dry_run" {
  description = "A list of all [egress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#egress-rules-reference), each list object has a `from` and `to` value that describes egress_from and egress_to."
  type = list(object({
    from = any
    to   = any
  }))
  default = []
}

## Have to solve it like this don't want use optional flag because is still experimental
variable "ingress_policies_dry_run" {
  description = "A list of all [ingress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#ingress-rules-reference), each list object has a `from` and `to` value that describes ingress_from and ingress_to."
  type = list(object({
    from = any
    to   = any
  }))
  default = []
}
