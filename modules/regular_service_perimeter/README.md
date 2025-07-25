# Access Perimeter Submodule

This module handles opiniated configuration and deployment of a [access_context_manager_service_perimeter](https://www.terraform.io/docs/providers/google/r/access_context_manager_service_perimeter.html) resource for regular service perimeter types.

## Usage
```hcl
provider "google" {
  version     = "~> 2.5.0"
}

module "org_policy" {
  source      = "terraform-google-modules/vpc-service-controls/google"
  parent_id   = var.parent_id
  policy_name = var.policy_name
}

module "regular_service_perimeter_1" {
  source         = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  policy         = module.org_policy.policy_id
  perimeter_name = "regular_perimeter_1"
  description    = "Some description"
  resources      = ["1111111111"]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  ingress_policies = [{
      "from" = {
        "sources" = {
          resources = [
            "projects/688789777678",
            "projects/557367936583"
          ],
          access_levels = [
              "some_access_level_name"
          ]
        },
        "identity_type" = ""
        "identities"    = ["some_user_identity or service account"]
      }
      "to" = {
        "operations" = {
          "bigquery.googleapis.com" = {
            "methods" = [
              "BigQueryStorage.ReadRows",
              "TableService.ListTables"
            ],
            "permissions" = [
              "bigquery.jobs.get"
            ]
          }
          "storage.googleapis.com" = {
            "methods" = [
              "google.storage.objects.create"
            ]
          }
        }
      }
    },
  ]
  egress_policies = [{
       "from" = {
        "identity_type" = ""
        "identities"    = ["some_user_identity or service account"]
      },
       "to" = {
        "resources" = ["*"]
        "operations" = {
          "bigquery.googleapis.com" = {
            "methods" = [
              "BigQueryStorage.ReadRows",
              "TableService.ListTables"
            ],
            "permissions" = [
              "bigquery.jobs.get"
            ]
          }
          "storage.googleapis.com" = {
            "methods" = [
              "google.storage.objects.create"
            ]
          }
        }
      }
    },
  ]

  shared_resources = {
    all = ["1111111111"]
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_levels | A list of AccessLevel resource names that allow resources within the ServicePerimeter to be accessed from the internet. AccessLevels listed must be in the same policy as this ServicePerimeter. Referencing a nonexistent AccessLevel is a syntax error. If no AccessLevel names are listed, resources within the perimeter can only be accessed via GCP calls with request origins within the perimeter. Example: 'accessPolicies/MY\_POLICY/accessLevels/MY\_LEVEL'. For Service Perimeter Bridge, must be empty. | `list(string)` | `[]` | no |
| access\_levels\_dry\_run | (Dry-run) A list of AccessLevel resource names that allow resources within the ServicePerimeter to be accessed from the internet. AccessLevels listed must be in the same policy as this ServicePerimeter. Referencing a nonexistent AccessLevel is a syntax error. If no AccessLevel names are listed, resources within the perimeter can only be accessed via GCP calls with request origins within the perimeter. Example: 'accessPolicies/MY\_POLICY/accessLevels/MY\_LEVEL'. For Service Perimeter Bridge, must be empty. If set, a dry-run policy will be set. | `list(string)` | `[]` | no |
| description | Description of the regular perimeter | `string` | n/a | yes |
| egress\_policies | A list of all [egress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#egress-rules-reference), each list object has a `from` and `to` value that describes egress\_from and egress\_to.<br><br>Example: `[{ from={ identities=[], identity_type="ID_TYPE" }, to={ resources=[], operations={ "SRV_NAME"={ OP_TYPE=[] }}}}]`<br><br>Valid Values:<br>`ID_TYPE` = `null` or `IDENTITY_TYPE_UNSPECIFIED` (only allow indentities from list); `ANY_IDENTITY`; `ANY_USER_ACCOUNT`; `ANY_SERVICE_ACCOUNT`<br>`SRV_NAME` = "`*`" (allow all services) or [Specific Services](https://cloud.google.com/vpc-service-controls/docs/supported-products#supported_products)<br>`OP_TYPE` = [methods](https://cloud.google.com/vpc-service-controls/docs/supported-method-restrictions) or [permissions](https://cloud.google.com/vpc-service-controls/docs/supported-method-restrictions) | <pre>list(object({<br>    title = optional(string, null)<br>    from = object({<br>      sources = optional(object({<br>        resources     = optional(list(string), [])<br>        access_levels = optional(list(string), [])<br>      }), {}),<br>      identity_type = optional(string, null)<br>      identities    = optional(list(string), null)<br>    })<br>    to = object({<br>      operations = optional(map(object({<br>        methods     = optional(list(string), [])<br>        permissions = optional(list(string), [])<br>      })), {}),<br>      roles              = optional(list(string), null)<br>      resources          = optional(list(string), ["*"])<br>      external_resources = optional(list(string), [])<br>    })<br>  }))</pre> | `[]` | no |
| egress\_policies\_dry\_run | A list of all [egress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#egress-rules-reference), each list object has a `from` and `to` value that describes egress\_from and egress\_to. Use same formatting as `egress_policies`. | <pre>list(object({<br>    title = optional(string, null)<br>    from = object({<br>      sources = optional(object({<br>        resources     = optional(list(string), [])<br>        access_levels = optional(list(string), [])<br>      }), {}),<br>      identity_type = optional(string, null)<br>      identities    = optional(list(string), null)<br>    })<br>    to = object({<br>      operations = optional(map(object({<br>        methods     = optional(list(string), [])<br>        permissions = optional(list(string), [])<br>      })), {}),<br>      roles              = optional(list(string), null)<br>      resources          = optional(list(string), ["*"])<br>      external_resources = optional(list(string), [])<br>    })<br>  }))</pre> | `[]` | no |
| egress\_policies\_keys | A list of keys to use for the Terraform state. The order should correspond to var.egress\_policies and the keys must not be dynamically computed. If `null`, var.egress\_policies will be used as keys. | `list(string)` | `null` | no |
| egress\_policies\_keys\_dry\_run | (Dry-run) A list of keys to use for the Terraform state. The order should correspond to var.egress\_policies\_dry\_run and the keys must not be dynamically computed. If `null`, var.egress\_policies\_dry\_run will be used as keys. | `list(string)` | `null` | no |
| ingress\_policies | A list of all [ingress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#ingress-rules-reference), each list object has a `from` and `to` value that describes ingress\_from and ingress\_to.<br><br>Example: `[{ from={ sources={ resources=[], access_levels=[] }, identities=[], identity_type="ID_TYPE" }, to={ resources=[], operations={ "SRV_NAME"={ OP_TYPE=[] }}}}]`<br><br>Valid Values:<br>`ID_TYPE` = `null` or `IDENTITY_TYPE_UNSPECIFIED` (only allow indentities from list); `ANY_IDENTITY`; `ANY_USER_ACCOUNT`; `ANY_SERVICE_ACCOUNT`<br>`SRV_NAME` = "`*`" (allow all services) or [Specific Services](https://cloud.google.com/vpc-service-controls/docs/supported-products#supported_products)<br>`OP_TYPE` = [methods](https://cloud.google.com/vpc-service-controls/docs/supported-method-restrictions) or [permissions](https://cloud.google.com/vpc-service-controls/docs/supported-method-restrictions) | <pre>list(object({<br>    title = optional(string, null)<br>    from = object({<br>      sources = optional(object({<br>        resources     = optional(list(string), [])<br>        access_levels = optional(list(string), [])<br>      }), {}),<br>      identity_type = optional(string, null)<br>      identities    = optional(list(string), null)<br>    })<br>    to = object({<br>      operations = optional(map(object({<br>        methods     = optional(list(string), [])<br>        permissions = optional(list(string), [])<br>      })), {}),<br>      roles     = optional(list(string), null)<br>      resources = optional(list(string), ["*"])<br>    })<br>  }))</pre> | `[]` | no |
| ingress\_policies\_dry\_run | A list of all [ingress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#ingress-rules-reference), each list object has a `from` and `to` value that describes ingress\_from and ingress\_to. Use same formatting as `ingress_policies`. | <pre>list(object({<br>    title = optional(string, null)<br>    from = object({<br>      sources = optional(object({<br>        resources     = optional(list(string), [])<br>        access_levels = optional(list(string), [])<br>      }), {}),<br>      identity_type = optional(string, null)<br>      identities    = optional(list(string), null)<br>    })<br>    to = object({<br>      operations = optional(map(object({<br>        methods     = optional(list(string), [])<br>        permissions = optional(list(string), [])<br>      })), {}),<br>      roles     = optional(list(string), null)<br>      resources = optional(list(string), ["*"])<br>    })<br>  }))</pre> | `[]` | no |
| ingress\_policies\_keys | A list of keys to use for the Terraform state. The order should correspond to var.ingress\_policies and the keys must not be dynamically computed. If `null`, var.ingress\_policies will be used as keys. | `list(string)` | `null` | no |
| ingress\_policies\_keys\_dry\_run | (Dry-run) A list of keys to use for the Terraform state. The order should correspond to var.ingress\_policies\_dry\_run and the keys must not be dynamically computed. If `null`, var.ingress\_policies\_dry\_run will be used as keys. | `list(string)` | `null` | no |
| perimeter\_name | Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores | `string` | n/a | yes |
| policy | Name of the parent policy | `string` | n/a | yes |
| resource\_keys | A list of keys to use for the Terraform state. The order should correspond to var.resources and the keys must not be dynamically computed. If `null`, var.resources will be used as keys. | `list(string)` | `null` | no |
| resource\_keys\_dry\_run | (Dry-run) A list of keys to use for the Terraform state. The order should correspond to var.resources\_dry\_run and the keys must not be dynamically computed. If `null`, var.resources\_dry\_run will be used as keys. | `list(string)` | `null` | no |
| resources | A list of GCP resources that are inside of the service perimeter. Currently only projects and VPC networks are allowed. | `list(string)` | `[]` | no |
| resources\_dry\_run | (Dry-run) A list of GCP resources that are inside of the service perimeter. Currently only projects and VPC networks are allowed. If set, a dry-run policy will be set. | `list(string)` | `[]` | no |
| restricted\_services | GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions. | `list(string)` | `[]` | no |
| restricted\_services\_dry\_run | (Dry-run) GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions.  If set, a dry-run policy will be set. | `list(string)` | `[]` | no |
| shared\_resources | A map of lists of resources to share in a Bridge perimeter module. Each list should contain all or a subset of the perimeters resources | `object({ all = list(string) })` | <pre>{<br>  "all": []<br>}</pre> | no |
| vpc\_accessible\_services | A list of [VPC Accessible Services](https://cloud.google.com/vpc-service-controls/docs/vpc-accessible-services) that will be restricted within the VPC Network. Use ["*"] to allow any service (disable VPC Accessible Services); Use ["RESTRICTED-SERVICES"] to match the restricted services list; Use [] to not allow any service. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| vpc\_accessible\_services\_dry\_run | (Dry-run) A list of [VPC Accessible Services](https://cloud.google.com/vpc-service-controls/docs/vpc-accessible-services) that will be restricted within the VPC Network. Use ["*"] to allow any service (disable VPC Accessible Services); Use ["RESTRICTED-SERVICES"] to match the restricted services list; Use [] to not allow any service. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| perimeter\_name | The perimeter's name. |
| resources | A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. |
| shared\_resources | A map of lists of resources to share in a Bridge perimeter module. Each list should contain all or a subset of the perimeters resources |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
