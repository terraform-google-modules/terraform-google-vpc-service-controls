# Upgrading to v4.x

The v4.x release is a backwards-incompatible release.

The `resources` inside perimeters have been split into their [own Terraform resource](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/access_context_manager_service_perimeter_resource).
This allows you to add resources (projects) to the perimeter from *outside* the module.

However, this change has a few implications:
1. Resources added to the perimeter out-of-band will no longer be removed by Terraform.
   You will need to develop an alternative system for dealing with these.
2. The location of resources has moved in the state file.
3. Because resources are now created using `for_each`, if the underlying project is created in the **same**
   Terraform configuration as the perimeter, you will need to provide a `resource_keys` variable.

## Dynamic resources
If resources are created inside the same configuration as the perimeter, you will received an error that their value cannot be determined until apply:
```
│ Error: Invalid for_each argument
│
│   on ../../modules/regular_service_perimeter/main.tf line 195, in resource "google_access_context_manager_service_perimeter_resource" "service_perimeter_resource":
│  195:   for_each       = local.resources
│     ├────────────────
│     │ local.resources will be known only after apply
```

To work around this, you need to provide a `resource_keys` variable input with keys for each resource. These keys are only used by Terraform and can be any alphanumeric string.

```diff
 module "regular_service_perimeter_2" {
   source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
-  version = "~> 3.0"
+  version = "~> 4.0"

  ...

  resources      = [module.project_two.project_number, module.project_three.project_number]
+ resource_keys  = ["two", "three"]
}

module "bridge" {
   source  = "terraform-google-modules/vpc-service-controls/google//modules/bridge_service_perimeter"
-  version = "~> 3.0"
+  version = "~> 4.0"

  ...

  resources = concat(
    module.regular_service_perimeter_1.shared_resources["all"],
    module.regular_service_perimeter_2.shared_resources["all"],
  )
+ resource_keys = ["one", "two", "three"]
}
```

## State migration

If you run `terraform plan` on an upgraded module, you will notice that Terraform wants to add `service_perimeter` resources.

```
Terraform will perform the following actions:

  # module.bridge.google_access_context_manager_service_perimeter_resource.service_perimeter_resource["projects/34502780858"] will be created
  + resource "google_access_context_manager_service_perimeter_resource" "service_perimeter_resource" {
      + id             = (known after apply)
      + perimeter_name = "accessPolicies/209696272439/servicePerimeters/bridge_perimeter_1"
      + resource       = "projects/34502780858"
    }

  # module.bridge.google_access_context_manager_service_perimeter_resource.service_perimeter_resource["projects/843696391937"] will be created
  + resource "google_access_context_manager_service_perimeter_resource" "service_perimeter_resource" {
      + id             = (known after apply)
      + perimeter_name = "accessPolicies/209696272439/servicePerimeters/bridge_perimeter_1"
      + resource       = "projects/843696391937"
    }

  # module.regular_service_perimeter_1.google_access_context_manager_service_perimeter_resource.service_perimeter_resource["34502780858"] will be created
  + resource "google_access_context_manager_service_perimeter_resource" "service_perimeter_resource" {
      + id             = (known after apply)
      + perimeter_name = "accessPolicies/209696272439/servicePerimeters/regular_perimeter_1"
      + resource       = "projects/34502780858"
    }

Plan: 3 to add, 0 to change, 0 to destroy.
```

For each resource, you will need to import it into the Terraform config:

```
terraform import 'module.bridge.google_access_context_manager_service_perimeter_resource.service_perimeter_resource["one"]' 'accessPolicies/209696272439/servicePerimeters/bridge_perimeter_1/projects/34502780858'
terraform import 'module.bridge.google_access_context_manager_service_perimeter_resource.service_perimeter_resource["two"]' 'accessPolicies/209696272439/servicePerimeters/bridge_perimeter_1/projects/843696391937'
terraform import 'module.regular_service_perimeter_1.google_access_context_manager_service_perimeter_resource.service_perimeter_resource["34502780858"]' 'accessPolicies/209696272439/servicePerimeters/regular_perimeter_1/projects/34502780858'
```
