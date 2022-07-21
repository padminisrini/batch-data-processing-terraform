# aws_batch_fargate

Terraform Code for AWS batch using fargate


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>3.38 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~>2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.75.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.13.0 |

## Resources

| Name | Type |
|------|------|
| [aws_batch_compute_environment.compute_environment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_compute_environment) | resource |
| [aws_batch_job_definition.job_defination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_job_definition) | resource |
| [aws_batch_job_queue.job_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_job_queue) | resource |
| [aws_iam_role.aws_batch_service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task_execution_service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aws_batch_service_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.task_execution_service_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.batch_security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_policy_document.batch_assume_role_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.batch_role_inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_assume_role_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_role_inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.container_properties](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_batch_service_role_policies"></a> [aws\_batch\_service\_role\_policies](#input\_aws\_batch\_service\_role\_policies) | List of aws managed policy to attached | `list(any)` | <pre>[<br>  "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"<br>]</pre> | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | aws region | `string` | `"us-east-2"` | no |
| <a name="input_aws_region_map"></a> [aws\_region\_map](#input\_aws\_region\_map) | n/a | `map(any)` | <pre>{<br>  "central": "c",<br>  "east": "e",<br>  "north": "n",<br>  "northeast": "ne",<br>  "south": "s",<br>  "southeast": "se",<br>  "west": "w"<br>}</pre> | no |
| <a name="input_batch_job_queue_priority"></a> [batch\_job\_queue\_priority](#input\_batch\_job\_queue\_priority) | The priority of the job queue. Job queues with a higher priority are evaluated first when associated with the same compute environment. | `number` | `1` | no |
| <a name="input_batch_job_queue_state"></a> [batch\_job\_queue\_state](#input\_batch\_job\_queue\_state) | The state of the job queue. Must be one of: ENABLED or DISABLED | `string` | `"ENABLED"` | no |
| <a name="input_compute_resources_type"></a> [compute\_resources\_type](#input\_compute\_resources\_type) | FARGATE\_SPOT or FARGATE | `string` | `"FARGATE"` | no |
| <a name="input_container_properties"></a> [container\_properties](#input\_container\_properties) | container properties required in job defination | <pre>object({<br>    container_environment = list(list(map(any)))<br>    job_defination        = list(map(any))<br>  })</pre> | <pre>{<br>  "container_environment": [<br>    [<br>      {<br>        "name": "Service",<br>        "value": "Batch"<br>      },<br>      {<br>        "name": "Terraform",<br>        "value": "True"<br>      }<br>    ]<br>  ],<br>  "job_defination": [<br>    {<br>      "container_command": "ls -lrt",<br>      "container_image": "busybox",<br>      "container_memory": "512",<br>      "container_vcpu": "0.25",<br>      "fargate_platform_version": "1.4.0",<br>      "name": "job-defination"<br>    }<br>  ]<br>}</pre> | no |
| <a name="input_infra_label"></a> [infra\_label](#input\_infra\_label) | Infrastructre labelling to identify the aws resources | `string` | `""` | no |
| <a name="input_max_vcpus"></a> [max\_vcpus](#input\_max\_vcpus) | The maximum number of EC2 vCPUs that an environment can reach. | `number` | `20` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Private Subnet Id's | `list(any)` | `[]` | no |
| <a name="input_private_subnets_cidrs"></a> [private\_subnets\_cidrs](#input\_private\_subnets\_cidrs) | private subnets cidrs | `list(any)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_project_environment"></a> [project\_environment](#input\_project\_environment) | project environment | `string` | `"dev"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | project name | `string` | `"demo"` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Public Subnet Id's | `list(any)` | `[]` | no |
| <a name="input_public_subnets_cidrs"></a> [public\_subnets\_cidrs](#input\_public\_subnets\_cidrs) | public subnets cidrs | `list(any)` | <pre>[<br>  "10.0.101.0/24",<br>  "10.0.102.0/24",<br>  "10.0.103.0/24"<br>]</pre> | no |
| <a name="input_task_execution_service_role_policies"></a> [task\_execution\_service\_role\_policies](#input\_task\_execution\_service\_role\_policies) | List of aws managed policy to attached | `list(any)` | <pre>[<br>  "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"<br>]</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC cidrs | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id (optional) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_compute_environment_arn"></a> [compute\_environment\_arn](#output\_compute\_environment\_arn) | The arn for your compute environment |
| <a name="output_compute_environment_name"></a> [compute\_environment\_name](#output\_compute\_environment\_name) | The name for your compute environment |
| <a name="output_compute_environment_state"></a> [compute\_environment\_state](#output\_compute\_environment\_state) | The state of the compute environment. If the state is ENABLED, then the compute environment accepts jobs from a queue and can scale out automatically based on queues. Valid items are ENABLED or DISABLED. Defaults to ENABLED. |
| <a name="output_container_properties"></a> [container\_properties](#output\_container\_properties) | Fargate Container properties |
<!-- END_TF_DOCS -->