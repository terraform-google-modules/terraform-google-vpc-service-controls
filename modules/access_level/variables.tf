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

variable "name" {
  description = "Description of the AccessLevel and its use. Does not affect behavior."
}

variable "policy" {
  description = "Name of the parent policy"
}

variable "combining_function" {
  description = "How the conditions list should be combined to determine if a request is granted this AccessLevel. If AND is used, each Condition must be satisfied for the AccessLevel to be applied. If OR is used, at least one Condition must be satisfied for the AccessLevel to be applied."
  default     = "AND"
}

variable "description" {
  description = "Description of the access level"
  default     = ""
}

variable "ip_subnetworks" {
  description = "Condition - A list of CIDR block IP subnetwork specification. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated (i.e. all the host bits must be zero) or the input is considered malformed. For example, \"192.0.2.0/24\" is accepted but \"192.0.2.1/24\" is not. Similarly, for IPv6, \"2001:db8::/32\" is accepted whereas \"2001:db8::1/32\" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed."
  type        = "list"
  default     = []
}

variable "required_access_levels" {
  description = "Condition - A list of other access levels defined in the same Policy, referenced by resource name. Referencing an AccessLevel which does not exist is an error. All access levels listed must be granted for the Condition to be true."
  type        = "list"
  default     = []
}

variable "members" {
  description = "Condition - An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = "list"
  default     = []
}

variable "negate" {
  description = "Whether to negate the Condition. If true, the Condition becomes a NAND over its non-empty fields, each field must be false for the Condition overall to be satisfied."
  default     = "false"
}

variable "require_screen_lock" {
  description = "Condition - Whether or not screenlock is required for the DevicePolicy to be true."
  default     = "false"
}

variable "allowed_encryption_statuses" {
  description = "Condition - A list of allowed encryptions statuses. An empty list allows all statuses."
  type        = "list"
  default     = []
}

variable "allowed_device_management_levels" {
  description = "Condition - A list of allowed device management levels. An empty list allows all management levels."
  type        = "list"
  default     = []
}

variable "minimum_version" {
  description = "The minimum allowed OS version. If not set, any version of this OS satisfies the constraint. Format: \"major.minor.patch\" such as \"10.5.301\", \"9.2.1\"."
  default     = ""
}

variable "os_type" {
  description = "The operating system type of the device."
  default     = ""
}
