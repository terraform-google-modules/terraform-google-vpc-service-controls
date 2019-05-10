# terraform-google-vpc-service-controls

This module handles opiniated VPC Service Controls and Access Context Manager configuration and deployments.

## Usage
The root module only handles the configuration of the [access_context_manager_policy resource](https://www.terraform.io/docs/providers/google/r/access_context_manager_access_policy.html). For examples on how to use the root module with along with other submodules to configure all of VPC Service Controls and Access Context Manager resources, see the [examples](./examples/) folder and the [modules](./modules/) folder

```hcl
provider "google" {
  version     = "~> 2.5.0"
  credentials = "${file("${var.credentials_path}")}"
}

module "org_policy" {
  source      = "terraform-google-modules/vpc-service-controls/google"
  parent_id   = "${var.parent_id}"
  policy_name = "${var.policy_name}"
}

module "access_level_members" {
  source   = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  policy      = "${module.org_policy.policy_id}"
  name        = "terraform_members"
  members  = "${var.members}"
}

module "regular_service_perimeter_1" {
   source         = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  policy         = "${module.org_policy.policy_id}"
  perimeter_name = "regular_perimeter_1"

  description    = "Perimeter shielding projects"
  resources      = ["1111111"]

  access_levels = ["${module.access_level_members.name}"]
  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  shared_resources = {
    all = ["11111111"]
  }
}
```

Then perform the following commands on the root folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

### Known limitations

The [Access Context Manager API](https://cloud.google.com/access-context-manager/docs/) guarantees that resources will be created, but there may be a delay between a successful response and the change taking effect. For example, ["after you create a service perimeter, it may take up to 30 minutes for the changes to propagate and take effect"](https://cloud.google.com/vpc-service-controls/docs/create-service-perimeters).
Because of these limitations in the API, you may first get an error when running `terraform apply` for the first time. However, for the [examples](./examples/) you should be able to succesfully deploy all resources by running `terraform apply` a second about 15 seconds after running it for the first time.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | string | n/a | yes |
| policy\_name | The policy's name. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy\_id | Resource name of the AccessPolicy. |
| policy\_name | The policy's name. |

[^]: (autogen_docs_end)

## Requirements

Before this module can be used on a project, you must ensure that the following pre-requisites are fulfilled:

1. Terraform is [installed](#software-dependencies) on the machine where Terraform is executed.
2. The Service Account you execute the module with has the right [permissions](#configure-a-service-account).
3. The necessary APIs are [active](#enable-apis) on the project.

The [project factory](https://github.com/terraform-google-modules/terraform-google-project-factory) can be used to provision projects with the correct APIs active.

### Software Dependencies
### Terraform
- [Terraform](https://www.terraform.io/downloads.html) 0.11.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v2.0.0

### Configure a Service Account

#### Organization level permissions
In order to create a policy, you need to grant your service account the Access Context Manager Admin role at the organization level:
- roles/accesscontextmanager.policyAdmin

You may use the following command:
`gcloud organizations add-iam-policy-binding ORGANIZATION_ID \
  --member="serviceAccount:example@project_id.iam.gserviceaccount.com" \
  --role="roles/accesscontextmanager.policyAdmin"`

### Configure user permission
In order to view VPC Service Controls and Access Context Manger using the Google Cloud Platform Console, your user accounts will need to be granted the Resource Manager Organization Viewer:
- roles/resourcemanager.organizationViewer

You may use the following command:
`gcloud projects add-iam-policy-binding <my project id> \
  --member="user:example@domain.com" \
  --role="roles/resourcemanager.organizationViewer"`

For more information see the [Access Context Manager ACL Page](https://cloud.google.com/access-context-manager/docs/access-control)


### Enable APIs
In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Storage JSON API - storage-api.googleapis.com
- Big Query API - bigquery.googleapis.com

## Install

Be sure you have the correct Terraform version (0.11.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/


## Testing

### Requirements
- [bundler](https://github.com/bundler/bundler)
- [gcloud](https://cloud.google.com/sdk/install)
- [terraform-docs](https://github.com/segmentio/terraform-docs/releases) 0.3.0

### Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

### Integration test

Integration tests are run though [test-kitchen](https://github.com/test-kitchen/test-kitchen), [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform), and [InSpec](https://github.com/inspec/inspec).

`test-kitchen` instances are defined in [`.kitchen.yml`](./.kitchen.yml). The test-kitchen instances in `test/fixtures/` wrap identically-named examples in the `examples/` directory.

#### Setup

1. Configure the [test fixtures](#test-configuration)
2. Download a Service Account key with the necessary permissions and put it in the module's root directory with the name `credentials.json`.
3. Build the Docker container for testing:

  ```
  make docker_build_kitchen_terraform
  ```
4. Run the testing container in interactive mode:

  ```
  make docker_run
  ```

  The module root directory will be loaded into the Docker container at `/cft/workdir/`.
5. Run kitchen-terraform to test the infrastructure:

  1. `kitchen create` creates Terraform state and downloads modules, if applicable.
  2. `kitchen converge` creates the underlying resources. Run `kitchen converge <INSTANCE_NAME>` to create resources for a specific test case.
  3. `kitchen verify` tests the created infrastructure. Run `kitchen verify <INSTANCE_NAME>` to run a specific test case.
  4. `kitchen destroy` tears down the underlying resources created by `kitchen converge`. Run `kitchen destroy <INSTANCE_NAME>` to tear down resources for a specific test case.

Alternatively, you can simply run `make test_integration_docker` to run all the test steps non-interactively.

#### Known Issues when running tests inside container
When running the example using the interactive shell (`make docker_run`) kitchen fails to read :
credentials.json. The $GOOGLE_APPLICATION_CREDENTIALS variable is set to a tmp dir (i.e `/tmp/tmp.NFHS144`)

#### Test configuration

Each test-kitchen instance is configured with a `variables.tfvars` file in the test fixture directory. For convenience, since all of the variables are project-specific, these files have been symlinked to `test/fixtures/shared/terraform.tfvars`.
Similarly, each test fixture has a `variables.tf` to define these variables, and an `outputs.tf` to facilitate providing necessary information for `inspec` to locate and query against created resources.

Each test-kitchen instance creates necessary fixtures to house resources.

### Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

### Linting
The makefile in this project will lint or sometimes just format any shell,
Python, golang, Terraform, or Dockerfiles. The linters will only be run if
the makefile finds files with the appropriate file extension.

All of the linter checks are in the default make target, so you just have to
run

```
make -s
```

The -s is for 'silent'. Successful output looks like this

```
Running shellcheck
Running flake8
Running go fmt and go vet
Running terraform validate
Running hadolint on Dockerfiles
Checking for required files
Testing the validity of the header check
..
----------------------------------------------------------------------
Ran 2 tests in 0.026s

OK
Checking file headers
The following lines have trailing whitespace
```

The linters
are as follows:
* Shell - shellcheck. Can be found in homebrew
* Python - flake8. Can be installed with 'pip install flake8'
* Golang - gofmt. gofmt comes with the standard golang installation. golang
is a compiled language so there is no standard linter.
* Terraform - terraform has a built-in linter in the 'terraform validate'
command.
* Dockerfiles - hadolint. Can be found in homebrew
