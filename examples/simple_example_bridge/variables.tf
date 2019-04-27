variable "parent_id" {
  description = "The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent."
}

variable "policy_name" {
  description = "The policy's name."
}

variable "protected_project_ids" {
  description = "Project id and number of the project INSIDE the regular service perimeter"
  type        = "map"

  default {
    id     = "sample-project-id"
    number = "01010101"
  }
}

variable "public_project_ids" {
  description = "Project id and number of the project OUTSIDE of the regular service perimeter. This variable is only necessary for running integration tests."
  type        = "map"

  default = {
    id     = "sample-project-id"
    number = "01010101"
  }
}
