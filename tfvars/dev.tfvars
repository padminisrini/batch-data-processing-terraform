###########################################################################################################
/* COMMON */
###########################################################################################################

pr_name = "food-processing"
tags = {
    AUTHOR 		= "PADMINI"
    PROJECT 		= "Batch"
    ENVIRONMENT 	= "DEVELOPMENT"	
}

###########################################################################################################
/* VPC */
###########################################################################################################

vpc_cidr = "172.16.0.0/20"
public_subnet_cidrs   = ["172.16.0.0/24", "172.16.1.0/24", "172.16.2.0/24"]
private_subnet_cidrs  = ["172.16.3.0/24", "172.16.4.0/24", "172.16.5.0/24"]
database_subnet_cidrs = ["172.16.6.0/24", "172.16.7.0/24", "172.16.8.0/24"]
public_subnet_name   = "bigdata-public"
private_subnet_name  = "bigdata-private"
database_subnet_name = "bigdata-database"

#############################################################################################################
/* DYNAMO DB */
#############################################################################################################

create_table = true
hash_key = "id"
range_key = "inspection_result"
billing_mode = "PAY_PER_REQUEST"
attributes = [
    {
        name = "id"
        type = "S"
    },
    {
        name = "inspection_result"
        type = "S"
    }
    
]

#############################################################################################################
/* S3 */
#############################################################################################################

create_bucket = true
bucket = "batch-processing-emr"

#############################################################################################################
/* Batch */
#############################################################################################################

create_lambda = true
function_name = "trigger-emr-function"
handler = "batch-trigger.lambda_handler"
role_name = "trigger-emr-role"
runtime = "python3.8"
description = "Lambda function to trigger EMR"
memory_size = "128"
timeout = "120"
name = "Food-processing-batch"
inputFileName = "food_establishment_data.csv" 
bucket_key = "csv/"
container_command =  "python , src/validation.py "
container_properties = {
    container_environment = [
      [{ "name" : "Service", "value" : "Batch" }, { "name" : "Terraform", "value" : "True" }]
    ]
    job_definition = [{
      "container_image"          : "xxxxx.dkr.ecr.eu-west-1.amazonaws.com/batch-processing:latest",
      "fargate_platform_version" : "LATEST",
      "container_vcpu"           : "0.25",
      "container_memory"         : "512",
      "name"                     : "job-definition"
    }]
  }

#############################################################################################################
/* EMR */
#############################################################################################################

ebs_root_volume_size = 10
visible_to_all_users = true
release_label = "emr-5.36.0"
applications = ["Hive" , "HBase" , "Hue" , "Phoenix"]
core_instance_group_instance_type = "m5.xlarge"
core_instance_group_instance_count = 2
core_instance_group_ebs_size = 32
core_instance_group_ebs_type = "gp2"
core_instance_group_ebs_volumes_per_instance = 2
master_instance_group_instance_type = "m5.xlarge"
master_instance_group_instance_count = 1
master_instance_group_ebs_size = 32
master_instance_group_ebs_type = "gp2"
master_instance_group_ebs_volumes_per_instance = 2
create_task_instance_group = false
key_pair_name = "emr-key-pair"
create_emr = true


layer_name = "lambda-layer-v1"