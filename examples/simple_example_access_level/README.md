# Simple Example Access Level

This example illustrates how to use the `vpc-service-controls` module to configure an org policy and an access level

# Requirements
1. Make sure you've gone through the root [Requirement Section](../../#requirements)
2. Select 2 projects in your organization that will part of 2 different regular service perimeters.
3. Enable the BigQuery API on both projects
4. Copy your credentials.json key in this directory. 
(Warning: this repo already has .gitignore configure to not track credentials.json files. If you are copying this example in a different repo, make sure to configure your .gitignore in the same fashion.)



[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | string | n/a | yes |
| policy\_name | The policy's name. | string | n/a | yes |
| protected\_project\_ids | Project id and number of the project INSIDE the regular service perimeter | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| parent\_id |  |
| policy\_name |  |

[^]: (autogen_docs_end)
