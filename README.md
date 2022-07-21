# aws_terraform_batch_emr_data_processing

Terraform Code that process a csv file uploaded in S3 in batch and big data analysis using EMR

## Usage


**How to run the project:** 
1. terraform init
2. terraform plan -var-file="tfvars/dev.tfvars"
3. terraform apply -var-file="tfvars/dev.tfvars"
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

| Name | Type |
|------|------|
| [aws-terraform-vpc-module]| Module |
| [aws-terraform-dynamoDB-module]| Module |
| [aws-terraform-s3-module] | Module |
| [aws-terraform-batch-module]| Module |
| [aws-terraform-emr-module]| Module |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="vpc_cidr"></a> [vpc\_cidr](#vpc\_cidr) | CIDR Range for the VPC | `string` | `""` | yes |
| <a name="public_subnet_name"></a> [public\_subnet\_name](#public\_subnet\_name) | Name of the public subnet | `string` | `""` | yes |
| <a name="private_subnet_name"></a> [private\_subnet\_name](#private\_subnet\_name) | Name of the private subnet | `string` | `""` | yes |
| <a name="public_subnet_cidrs"></a> [public\_subnet\_cidrs](#public_subnet_cidrs) | Public subnet cidrs | `list(string)` | `[]` | no |
| <a name="private_subnet_cidrs"></a> [private\_subnet\_cidrs](#private\_subnet\_cidrs) | Private subnet cidrs | `list(string)` | `null` | yes |
| <a name="public_subnet_azs"></a> [public\_subnet\_azs](#public\_subnet\_azs) | Public subnet azs | `list(string)` | `null` | yes |
| <a name="private_subnet_azs"></a> [private_subnet_azs](#private\_subnet\_azs) | Private subnet az | `list(string)` | `null` | yes |
| <a name="input_create_table"></a> [create\_table](#input\_create\_table) | Controls if DynamoDB table and associated resources are created | `bool` | `true` | no |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | The attribute to use as the range (sort) key. Must also be defined as an attribute | `string` | `null` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | The attribute to use as the hash (partition) key. Must also be defined as an attribute | `string` | `null` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | List of nested attribute definitions. Only required for hash\_key and range\_key attributes. Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data | `list(map(string))` | `[]` | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | Controls how you are billed for read/write throughput and how you manage capacity. The valid values are PROVISIONED or PAY\_PER\_REQUEST | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="create_bucket"></a> [create\_bucket](#create\_bucket) | Decides whether the bucket to be created or not | `bool` | `true` | yes |
| <a name="bucket"></a> [bucket](#bucket) | Name of the bucket | `any` | `[]` | no |
| <a name="input_container_properties"></a> [container\_properties](#input\_container\_properties) | container properties required in job defination | <pre>object({<br>    container_environment = list(list(map(any)))<br>    job_defination        = list(map(any))<br>  })</pre> | <pre>{<br>  "container_environment": [<br>    [<br>      {<br>        "name": "Service",<br>        "value": "Batch"<br>      },<br>      {<br>        "name": "Terraform",<br>        "value": "True"<br>      }<br>    ]<br>  ],<br>  "job_defination": [<br>    {<br>      "container_command": "ls -lrt",<br>      "container_image": "busybox",<br>      "container_memory": "512",<br>      "container_vcpu": "0.25",<br>      "fargate_platform_version": "1.4.0",<br>      "name": "job-defination"<br>    }<br>  ]<br>}</pre> | no |
| <a name="input_ebs_root_volume_size"></a> [ebs\_root\_volume\_size](#input\_ebs\_root\_volume\_size) | Size in GiB of the EBS root device volume of the Linux AMI that is used for each EC2 instance. Available in Amazon EMR version 4.x and later | `number` | `10` | no |
| <a name="input_visible_to_all_users"></a> [visible\_to\_all\_users](#input\_visible\_to\_all\_users) | Whether the job flow is visible to all IAM users of the AWS account associated with the job flow | `bool` | `true` | no |
| <a name="input_release_label"></a> [release\_label](#input\_release\_label) | The release label for the Amazon EMR release. https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-release-5x.html | `string` | `"emr-5.25.0"` | no |
| <a name="input_applications"></a> [applications](#input\_applications) | A list of applications for the cluster. Valid values are: Flink, Ganglia, Hadoop, HBase, HCatalog, Hive, Hue, JupyterHub, Livy, Mahout, MXNet, Oozie, Phoenix, Pig, Presto, Spark, Sqoop, TensorFlow, Tez, Zeppelin, and ZooKeeper (as of EMR 5.25.0). Case insensitive | `list(string)` | n/a | yes |
| <a name="input_core_instance_group_ebs_size"></a> [core\_instance\_group\_ebs\_size](#input\_core\_instance\_group\_ebs\_size) | Core instances volume size, in gibibytes (GiB) | `number` | n/a | yes |
| <a name="input_core_instance_group_ebs_type"></a> [core\_instance\_group\_ebs\_type](#input\_core\_instance\_group\_ebs\_type) | Core instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1` | `string` | `"gp2"` | no |
| <a name="input_core_instance_group_ebs_volumes_per_instance"></a> [core\_instance\_group\_ebs\_volumes\_per\_instance](#input\_core\_instance\_group\_ebs\_volumes\_per\_instance) | The number of EBS volumes with this configuration to attach to each EC2 instance in the Core instance group | `number` | `1` | no |
| <a name="input_core_instance_group_instance_count"></a> [core\_instance\_group\_instance\_count](#input\_core\_instance\_group\_instance\_count) | Target number of instances for the Core instance group. Must be at least 1 | `number` | `1` | no |
| <a name="input_core_instance_group_instance_type"></a> [core\_instance\_group\_instance\_type](#input\_core\_instance\_group\_instance\_type) | EC2 instance type for all instances in the Core instance group | `string` | n/a | yes |
| <a name="input_master_instance_group_ebs_size"></a> [master\_instance\_group\_ebs\_size](#input\_master\_instance\_group\_ebs\_size) | Master instances volume size, in gibibytes (GiB) | `number` | n/a | yes |
| <a name="input_master_instance_group_ebs_type"></a> [master\_instance\_group\_ebs\_type](#input\_master\_instance\_group\_ebs\_type) | Master instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1` | `string` | `"gp2"` | no |
| <a name="input_master_instance_group_ebs_volumes_per_instance"></a> [master\_instance\_group\_ebs\_volumes\_per\_instance](#input\_master\_instance\_group\_ebs\_volumes\_per\_instance) | The number of EBS volumes with this configuration to attach to each EC2 instance in the Master instance group | `number` | `1` | no |
| <a name="input_master_instance_group_instance_count"></a> [master\_instance\_group\_instance\_count](#input\_master\_instance\_group\_instance\_count) | Target number of instances for the Master instance group. Must be at least 1 | `number` | `1` | no |
| <a name="input_master_instance_group_instance_type"></a> [master\_instance\_group\_instance\_type](#input\_master\_instance\_group\_instance\_type) | EC2 instance type for all instances in the Master instance group | `string` | n/a | yes |

## Outputs

| Name | Description |
| <a name="vpc_id"></a> [vpc\_id](#vpc\_id) | VPC ID |
| <a name="vpc_cidr"></a> [vpc\_cidr](#vpc\_cidr) | CIDR Range of VPC|
| <a name="source_s3_bucket_arn"></a> [source\_s3\_bucket\_id](#source\_s3\_buvket\_id) | ID of the bucket|
| <a name="destination_s3_bucket_arn"></a> [destination\_s3\_bucket\_arn](#destination\_s3\_bucket\_arn) | Arn of the Destination bucket |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | EMR cluster ID |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | EMR cluster name |
| <a name="output_dynamodb_table_arn"></a> [dynamodb\_table\_arn](#output\_dynamodb\_table\_arn) | ARN of the DynamoDB table |
| <a name="output_dynamodb_table_id"></a> [dynamodb\_table\_id](#output\_dynamodb\_table\_id) | ID of the DynamoDB table |
| <a name="output_compute_environment_arn"></a> [compute\_environment\_arn](#output\_compute\_environment\_arn) | The arn for your compute environment |
| <a name="output_compute_environment_name"></a> [compute\_environment\_name](#output\_compute\_environment\_name) | The name for your compute environment |
| <a name="batch_lambda_function_arn"></a> [batch\_lambda\_function\_arn](#batch\_lambda\_function\_arn) | Batch lambda arn|
<!-- markdownlint-restore -->
<!-- END_TF_DOCS -->