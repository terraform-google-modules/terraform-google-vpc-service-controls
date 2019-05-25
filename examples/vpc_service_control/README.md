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

The resources in this demo cost approx $14/day (or $0.58/hour) if you leave them up and running.  Luckily, Terraform makes it easy to spin the resources up and down on-demand.

## An important note about security
If you're going to modify this code and check it in to your code repo:
- Do not check in the service account .json file.  A bad guy who accesses this file could do serious damage to your project.
- Do not check in a completed `terraform.tfvars` file.  A bad guy who sees your VPN public IP's and shared secrets could gain access to your network.

We recommend that you delete the service account .json file and delete the service account altogether when you've completed running through this demo.

## Prerequisites
To complete this demo, you'll need:
- A Google Cloud [organization](https://cloud.google.com/resource-manager/docs/quickstart-organizations) mapped to a domain that you own with at least one project already created.
- A valid billing account where you have Billing Account Admin privileges.
- A service account with Project Creator privileges.  Steps for provisioning this are included below, but those steps assume you have Organization Admin privileges.
- Terraform v0.11.13 with provider.google v2.6.0 (the only versions I've tested; run `terraform version` to see what you've got).

## Instructions

0. Set up the service account needed to run the Terraform code.
    - In an existing project, create the service account.  Copy and paste its email address (the big, long, `gserviceaccount.com` address) to a scratch pad.  Download its .json secret key file into the `onprem_project/` and also copy it into the `vpc_sc_project` folders.  Be **extremely careful** with this file; delete it when you're done with this example.
    - Go to the [IAM admin](https://console.cloud.google.com/iam-admin/iam) section of your *organization.*  (You should see your domain name at the top of the screen, not an individual project name).  Click Add.  In the "New Members" box, paste the email address of the service account you created.  Under the Roles dialog, search for "Project Creator."  Grant that role by clicking Save.  Your service account can now create projects and act as a project owner for those projects.
    - Go to the Billing section of the Cloud Console.  Select the billing account you want to charge for the projects you create.  (If you're using your credit card, the default limit is 5 projects mapped to a billing account, in case project creation fails for you in the steps below).  On the right side of the screen, there's a "Permissions" section for your billing account.  Click "Add members," and paste the email address of the service account you created.  Grant the service account Billing Admin privileges, so that it can map the projects it creates to your billing account.  **Note the billing account ID** (the alphanumeric text separated by hyphens), as we'll use it below.

1. Create the on-prem project.
    - In your favorite text editor, edit and save the following variables in `**onprem_project**/terraform.tfvars`:
        - `project_id`: the unique ID for the on-prem project that is going to be created.  Use lowercase letters and a 6 digit random number only (no spaces).
        - `service_account_file`: the name of the service account secret key file you downloaded.  Relative path is fine if you saved it in the `onprem_project` directory.
        - `organization_id`: run `gcloud organizations list` to get this **number**.
        - `billing_account_id`: the billing account that the project will charge to.
        - `cloud_router_region`: it can be any region you like, although I recommend sticking with us-west1 because I haven't tested other regions.
        - `shared_secret_string_for_vpn_connection`: any random text string can go here.
        - Leave the rest blank.
    - From a command line terminal:
        - `cd onprem_project`
        - `terraform plan`
            - It should show a plan to create one project, two routes, and one firewall rule.  
        - `terraform apply` and type "yes" when it prompts you to create the resources.  Might take a few minutes to create the project (should be less than 5 minutes).
        - You will get an error message saying the Compute Engine API isn't enabled.  There will be a URL in the error message.  Copy and paste the URL into a browser, and then enable the Compute Engine API (takes a few minutes; be patient, let the spinner spin).  Once it's enabled, run `terraform apply` again - it should succeed.

2. Create the project that will be protected by VPC Service Controls.
    - Edit and save the following variables in `**vpc_sc_project**/terraform.tfvars`:
        - `project_id`: create a *different* project ID from the one in step 1
        - `service_account_file`
        - `organization_id`: should be *same* as in step 1
        - `billing_account_id`: *same* as in step 1
        - `cloud_router_region`: *same* as in step 1
        - `shared_secret_string_for_vpn_connection`: *same* as in step 1
        - Leave the rest blank.
    - From a command line terminal:
        - `cd ../vpc_sc_project`
        - `terraform plan`
            - It should show a plan to create one project, one network, one subnet, one firewall rule, one route.
        - `terraform apply`
            - You might not get the "Compute Engine API" error message here, but if you do, enable it and try again.

3. Reserve a public IP for your "on-prem" VPN router (to be clear, further use of "on-prem" in these instructions refers to the GCP project that we're pretending is your on-prem environment).
    - Open `onprem_project/main.tf` in your favorite text editor.
    - Search for `STEP 1A`.
    - Don't actually delete the line; just add `*/` to the **end** of the line.
    - Search for `STEP 1B`.
    - Don't actually delete the line; just add `/*` to the **beginning** of the line.
    - Save file.
    - `cd onprem_project/`
    - `terraform plan` and make sure it says it's going to reserve an IP address
    - `terraform apply`
    - Write down the public IP address that is printed on the terminal when the command succeeds.
    - **Important:**  Insert the public IP address into `**vpc_sc_project**/terraform.tfvars` under `ip_addr_of_onprem_vpn_router`.

4. Reserve a public IP for your VPC Service Control project's VPN router.
    - Follow all the steps in step 3, but instead do it in `vpc_sc_project/main.tf` and search for `STEP 2A` and `STEP 2B`.
    - Write down the public IP address that is printed on the terminal when the command succeeds.
    - **Important:**  Insert the public IP address into `**onprem_project**/terraform.tfvars` under `ip_addr_of_cloud_vpn_router`.
    - Now the two VPN routers in each project will know how to find each other.
    
5. Spin up the VPN router, Cloud Router, and VPN tunnel in on-prem project.
    - Edit `onprem_project/main.tf`
    - Delete `STEP 3A` and `STEP 3B` lines (comment them instead of actually deleting for best results).
    - `cd onprem_project/`
    - `terraform plan`
    - `terraform apply`

6. Spin up the VPN router, Cloud Router, and VPN tunnel in the VPC Service Control project.
    - Same as step 5, but with `vpc_sc_project/main.tf` and `STEP 4A` and `STEP 4B`
    - Once this is done, open the Cloud Console for either project.  Go to the Hybrid Connectivity -> VPN section, and click on the VPN tunnel you created.  You should see the connection established to the other VPN router, and it should say that the BGP session is established.

7.  Continue bouncing back and forth between the two `main.tf` files, uncommenting code blocks in numeric order for `STEP 5A`, `6A`, `7A`, and running `terraform apply` after uncommenting each code block.
    - `7A` is in `vpc_sc_project/main.tf`.  It will prompt you to enable the Cloud DNS API.  Enable it.

TODO: Complete the remaining instructions with more detail.

8.  `STEP 8A` enables VPC Service Controls.  You can do this in Terraform; or you can go to the Security -> VPC Service Controls section of the Cloud Console and point and click around to explore this feature.

To gain access to a VM in the VPC Service Control protected environment:

- Set the Windows password for the jumphost in the on-prem project, and download the .rdp file
- Set the Windows password for the VPC SC Windows VM
- RDP into the jumphost using its public IP
- Once you're in the jumphost, click Start -> Remote Desktop, and then RDP into `10.7.0.2` (the internal IP of the VM in the VPC Service Controls perimeter).  So you RDP into the jumphost, and then you RDP through the VPN tunnel into your cloud VM.  
- Play around with VPC Service Controls.
- Remember to delete all resources when done.  Easiest way to do this is to revert the two main.tf files, such that the resources that cost money are commented out again.

When you're done with this demo and you're happy, delete the service account keys and delete the service account altogether from the Cloud Console.







        
        
