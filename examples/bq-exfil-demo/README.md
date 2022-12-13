# VPC Service Controls Demo

## Dependencies

* `gcloud/bq`
* Org Admin Role

## Overview

![](assets/arch.png)

This terraform code will create:

* 2 projects: source and target/attacker
* Bastion in a private subnet with Private Google Access enabled
* Firewall rule allowing SSH via IAP into the Bastion
* BigQuery Dataset/Table which is loaded with test data
* Target Bucket for the exfil attempt
* All necessary IAM bindings
* Org policy forbidding external IPs on Instances
* VPC Service Control perimeter around BigQuery and GCS in the source project

## Permissions

Since this example touches Org-level configuration, you should have pretty high permissions in your org to be able to use it. At minimum, you'll need:

### Org level
* roles/accesscontextmanager.policyAdmin
* roles/resourcemanager.organizationViewer
* roles/resourcemanager.projectCreator
* roles/billing.user

### Folder level

These are the roles necessary for the projects that will be created.

* roles/compute.networkAdmin
* roles/compute.xpnAdmin
* roles/iam.serviceAccountAdmin
* roles/resourcemanager.projectIamAdmin
* roles/bigquery.admin
* roles/storage.admin


## Deployment

```
cp terraform.tfvars.sample terraform.tfvars
```

Then update that file with your own values. With all the arguments set in the `terraform.tfvars` file, simply run

```
terraform apply
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| billing\_account | Billing Account id. e.g. AAAAAA-BBBBBB-CCCCCC | `string` | n/a | yes |
| enabled\_apis | List of APIs to enable on the created projects | `list(string)` | <pre>[<br>  "iap.googleapis.com",<br>  "oslogin.googleapis.com",<br>  "compute.googleapis.com",<br>  "bigquery.googleapis.com",<br>  "storage-api.googleapis.com"<br>]</pre> | no |
| folder\_id | Folder ID within the Organization: e.g. 1234567898765 | `string` | `""` | no |
| members | List of members in the standard GCP form: user:{email}, serviceAccount:{email}, group:{email} | `list(string)` | `[]` | no |
| org\_id | Organization ID. e.g. 1234567898765 | `string` | n/a | yes |
| region | Region where the bastion host will run | `string` | `"us-west1"` | no |
| terraform\_service\_account | The Terraform service account email that should still be allowed in the perimeter to create buckets, datasets, etc. | `string` | n/a | yes |
| zone | Zone where the bastion host will run | `string` | `"us-west1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| source\_project | n/a |
| target\_bucket | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Demo


First you'll want to get the bucket name from either the state output or looking it up in the console:

```
terraform output target_bucket
```

Next log into the Bastion instance using `gcloud`. Notice how it will say something about tunnelling through IAP?
That's because the instance doesn't have a public IP!

```
gcloud config set project $(terraform output source_project)
gcloud compute ssh bastion-vm
```

Once you're on the instance, you'll notice that you're logged in as the service account with a user like `sa_1234567890@bastion-vm` which tells you that OS Login was used.

Go ahead and take a look at your config, which should show you which service account you are using. You should be able to successfully run the following command and get some BigQuery data:

```
bq head project_1_dataset.cars
```


Now lets be a bit evil! We're going to attempt to exfil the data from this host to another GCP account that we own.
Since we own it, we can grant the Service Account for the bastion Owner permissions on the target account. This was already
done for you in the Terraform in `storage.tf`. Since we are Owner of the target account, without VPC SC, we could extract the
entire table into a GCS bucket that we own, but with VPC SC protecting our BigQuery, that won't work. Let's try it anyway!
Using the bucket name you printed earlier (we'll call it `BUCKET_URL`), let's try to extract the cars table to the target bucket.
You should get an output that looks something like this:

```
bq extract project_1_dataset.cars BUCKET_URL/cars.csv
BigQuery error in extract operation: VPC Service Controls: Request is prohibited by organization's policy.
```

Success!! Data exfil prevented! But what about PasteBin? Or AWS S3? Or any number of services??

If you look at the subnet we put our Bastion in, you'll notice the line:

```
private_ip_google_access = true
```

You also may notice that we didn't give this thing a NAT. This means we limited the scope of egress traffic to ONLY Google APIs,
which subsequently means that you can't make outbound requests to these type of storage services over the internet. Now does this
mean you are completely safe from exfil? Absolutely not! As long as the user's machine has access to the bastion she can SCP data
from that host. There are other controls you can add as well but VPC SC mitigates a very common threat of data exfil.
