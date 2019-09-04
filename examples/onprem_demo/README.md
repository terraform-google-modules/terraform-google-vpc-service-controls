# VPC Service Control Demo

This is a demo of a GCP project protected from internet access using [VPC Service Controls](https://cloud.google.com/vpc-service-controls/) (henceforth referred to as "VPC SC").  The Terraform code in `onprem_project/` and `vpc_sc_project/` directories does the following:

- Creates a project representing your on-prem network, with the [default network](https://cloud.google.com/vpc/docs/vpc#default-network) enabled
- Creates a project that will be protected with VPC SC with a custom network that has only one `10.7.0.0/16` subnet (purely for the sake of simplicity) in a region of your choice
- Creates a VPN tunnel connecting the two projects (this could conceptually represent a dedicated interconnect as well)
- Creates a Cloud Router in each project to exchange network routes between the two environments
- Launches one virtual machine in the VPC SC project: 
    - one Windows instance without an external IP address
- Launches two virtual machines in the on-prem project: 
    - one Linux instance acting as a forward proxy for all internet-bound requests; and 
    - one Windows instance representing an on-prem server.  You'll use this as a jumphost to RDP into the Windows instance in the VPC SC project.
- Configures routes and DNS resolution for [Google Private Access](https://cloud.google.com/vpc/docs/configure-private-google-access) in the VPC SC project, so GCP API calls from within your project never traverse the public internet
- Enables VPC Service Controls.  

You can optionally enable VPC SC using the Cloud Console instead of Terraform if you'd like to poke around at some of the features.

The resources in this demo cost approx $14/day (or $0.58/hour) if you leave them up and running.  Fortunately, Terraform makes it easy to spin the resources up and down on-demand.

## An important note about security
If you're going to modify this code and check it in to your code repo:
- Do not check in the service account .json file.  A bad guy who accesses this file could do serious damage to your project.
- Do not check in a completed `terraform.tfvars` file.  A bad guy who sees your VPN public IP's and shared secrets could gain access to your network.

We recommend that you delete the service account .json file and delete the service account altogether when you've completed running through this demo.

## Requirements
To complete this demo, you'll need:
- A Google Cloud [organization](https://cloud.google.com/resource-manager/docs/quickstart-organizations) mapped to a domain that you own with at least one project already created.
- A valid billing account where you have Billing Account User privileges.
- A service account with Project Creator privileges.  Steps for provisioning this are included below, but those steps assume you have Organization Admin privileges.
- Terraform v0.11.13 with provider.google v2.6.0 (the only versions I've tested; run `terraform version` to see what you've got).

## Instructions

0. Set up the service account needed to run the Terraform code.
    - In an existing project, create the service account.  Copy and paste its email address (the big, long, `gserviceaccount.com` address) to a scratch pad.  Download its .json secret key file into the `onprem_project/` and also copy it into the `vpc_sc_project` folders.  Be **extremely careful** with this file; delete it when you're done with this example.
    - Go to the [IAM admin](https://console.cloud.google.com/iam-admin/iam) section of your *organization.*  (You should see your domain name at the top of the screen, not an individual project name).  Click Add.  In the "New Members" box, paste the email address of the service account you created.  Under the Roles dialog, search for "Project Creator."  Grant that role by clicking Save.  Your service account can now create projects and act as a project owner for those projects.
    -  Add the additional Organization level permissions to the service account mentioned [here](https://github.com/terraform-google-modules/terraform-google-vpc-service-controls#organization-level-permissions) to  make sure your service account can create VPC SC otherwise known as Access Context Manager resources.
    - Go to the Billing section of the Cloud Console.  Select the billing account you want to charge for the projects you create.  (If you're using your credit card, the default limit is 5 projects mapped to a billing account, in case project creation fails for you in the steps below).  On the right side of the screen, there's a "Permissions" section for your billing account.  Click "Add members," and paste the email address of the service account you created.  Grant the service account Billing Account User privileges, so that it can map the projects it creates to your billing account.  **Note the billing account ID** (the alphanumeric text separated by hyphens), as we'll use it below.

1. Create the Terraform variables file.
    - In your favorite text editor, create and save a file named `terraform.tfvars` in the `examples/onprem_demo/` directory:

        - `vpc_sc_project_id`: the unique ID for the VPC Service Control project that is going to be created.  Use lowercase letters and a 6 digit random number only (no spaces).
        - `onprem_project_id`: the unique ID for the on-prem project that is going to be created.  Use lowercase letters and a 6 digit random number only (no spaces).
        - `credentials_path`: the name of the service account secret key file you downloaded.  Relative path is fine if you saved it in the `onprem_project` directory.
        - `organization_id`: run `gcloud organizations list` to get this **number**.
        - `billing_account_id`: the billing account that the project will charge to.
        - `region`: region where the GCP resources will be created. 
        - `vpn_shared_secret`: any random text string can go here.
        - `access_policy_name`: Get this value by running the following two commands:
            - `gcloud organizations list` to get the Organization ID
            - `gcloud access-context-manager policies list --organization <Organization ID>` 
            - If the above commands return an error message, or don't return a value at all, you may have to create a new access policy (instructions [here](https://cloud.google.com/sdk/gcloud/reference/access-context-manager/policies/create)).
2. From a command line terminal:
    - `cd examples/onprem_demo`
    - `terraform init`
    - `terraform plan`
    - `terraform apply` and type "yes" when it prompts you to create the resources.  Might take a few minutes to create the projects (should be less than 5 minutes).
    - If you get error messages about the Compute Engine API or Cloud DNS API needing to be enabled, wait a minute and try running `terraform apply` again.  If you get error messages about forwarding rules and VPN tunnel creation, wait a minute and try again.


To gain access to a VM in the VPC Service Control protected environment:

- Set the Windows password for the jumphost in the on-prem project, and download the .rdp file
- Set the Windows password for the VPC SC Windows VM
- RDP into the jumphost using its public IP
- Once you're in the jumphost, click Start -> Remote Desktop, and then RDP into `10.7.0.2` (the internal IP of the VM in the VPC Service Controls perimeter).  So you RDP into the jumphost, and then you RDP through the VPN tunnel into your cloud VM.  
- Play around with VPC Service Controls.
- Remember to delete all resources when done.  Easiest way to do this is to run `terraform destroy`.

When you're done with this demo, delete the service account keys and delete the service account altogether from the Cloud Console.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| access\_policy\_name | Name of the access policy | string | n/a | yes |
| billing\_account\_id | Billing account ID to which the new project should be associated | string | n/a | yes |
| credentials\_path | Path to the service account .json file | string | n/a | yes |
| onprem\_project\_id | The ID of the Onprem GCP project that is going to be created | string | n/a | yes |
| organization\_id | Organization ID, which can be found at `gcloud organizations list` | string | n/a | yes |
| region | GCP Region (like us-west1, us-central1, etc) | string | `"us-west1"` | no |
| vpc\_sc\_project\_id | The ID of the VPC Service Control project that is going to be created | string | n/a | yes |
| vpn\_shared\_secret | Shared secret string for VPN connection | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| windows\_cloud\_private\_ip | Private IP address for the 'cloud-based' Windows instance |
| windows\_onprem\_public\_ip | Public IP address for the 'onprem' Windows jumphost |

[^]: (autogen_docs_end)
