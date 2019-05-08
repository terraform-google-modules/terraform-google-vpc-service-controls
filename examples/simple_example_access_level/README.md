# Simple Example Access Level

This example illustrates how to use the `vpc-service-controls` module to configure an org policy and an access level

# Requirements
1. Make sure you've gone through the root [Requirement Section](../../#requirements)



[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials\_path | Path to credentials.json key for service account deploying resources | string | n/a | yes |
| ip\_subnetworks | A list of CIDR block IP subnetwork specification. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated (i.e. all the host bits must be zero) or the input is considered malformed. For example, "192.0.2.0/24" is accepted but "192.0.2.1/24" is not. Similarly, for IPv6, "2001:db8::/32" is accepted whereas "2001:db8::1/32" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed. | list | n/a | yes |
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | string | n/a | yes |
| policy\_name | The policy's name. | string | n/a | yes |
| protected\_project\_ids | Project id and number of the project INSIDE the regular service perimeter. This map variable expects an "id" for the project id and "number" key for the project number. | map | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy\_name |  |

[^]: (autogen_docs_end)
