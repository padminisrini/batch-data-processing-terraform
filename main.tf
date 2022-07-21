#######################################################################################################################
/*VARIABLES FOR VPC*/
#######################################################################################################################
module "aws-terraform-vpc-module" {
  source   = "./aws-terraform-vpc"
  vpc_cidr = var.vpc_cidr

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  public_subnet_azs  = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnet_azs = ["${var.region}a", "${var.region}b", "${var.region}c"]

  public_subnet_name  = var.public_subnet_name
  private_subnet_name = var.private_subnet_name
  tags                = var.tags
  pr_name             = var.pr_name
}

#######################################################################################################################
/*VARIABLES FOR DynamoDB*/
#######################################################################################################################

module "aws-terraform-dynamoDB-module" {
  source                   = "./aws-terraform-dynamoDB"
  create_table             = var.create_table
  hash_key                 = var.hash_key
  range_key                = var.range_key
  billing_mode             = var.billing_mode
  read_capacity            = var.read_capacity
  write_capacity           = var.write_capacity
  attributes               = var.attributes
  global_secondary_indexes = var.global_secondary_indexes
  replica_regions          = var.replica_regions
  tags                     = var.tags
  pr_name                  = var.pr_name
}

#######################################################################################################################
/*VARIABLES FOR S3*/
#######################################################################################################################

module "aws-terraform-s3-module" {
  source           = "./aws-terraform-s3"
  create_bucket    = var.create_bucket
  bucket           = var.bucket
  tags             = var.tags
  pr_name          = var.pr_name
  batch_lambda_arn = module.aws-terraform-batch-module.batch_lambda_function_arn

}

#######################################################################################################################
/*VARIABLES FOR Batch*/
#######################################################################################################################

module "aws-terraform-batch-module" {
  source                   = "./aws-terraform-batch"
  vpc_id                   = module.aws-terraform-vpc-module.vpc_id
  private_subnet_ids       = module.aws-terraform-vpc-module.private_subnet_ids
  public_subnets           = module.aws-terraform-vpc-module.public_subnet_ids
  batch_secuity_groups     = aws_security_group.batch_sg.id
  container_properties     = var.container_properties
  max_vcpus                = 10
  batch_job_queue_priority = 10
  #  ecr_image_url            = var.ecr_image_url
  # job_command              = var.job_command
  container_command = var.container_command
  dynamodb_table_name = module.aws-terraform-dynamoDB-module.dynamodb_table_id
  bucketName          = module.aws-terraform-s3-module.source_s3_bucket_name
  inputFileName       = var.inputFileName
  region              = var.region
  bucket_key          = var.bucket_key
  #Lambda
  create_lambda = var.create_lambda
  function_name = var.function_name
  role_name     = var.role_name
  handler       = var.handler
  runtime       = var.runtime
  description   = var.description
  memory_size   = var.memory_size
  timeout       = var.timeout
  pr_name       = var.pr_name
  tags          = var.tags
}

resource "aws_security_group" "batch_sg" {
  name        = "batch_sg"
  description = "Allow  inbound traffic"
  vpc_id      = module.aws-terraform-vpc-module.vpc_id

  ingress {
    description = "all traffic from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
}

#######################################################################################################################
/*VARIABLES FOR EMR*/
#######################################################################################################################

module "aws-terraform-emr-module" {
  source                                         = "./aws-terraform-emr"
  master_allowed_security_groups                 = [module.aws-terraform-vpc-module.aws_default_security_group]
  slave_allowed_security_groups                  = [module.aws-terraform-vpc-module.aws_default_security_group]
  region                                         = var.region
  create_emr                                     = var.create_emr
  vpc_id                                         = module.aws-terraform-vpc-module.vpc_id
  subnet_id                                      = module.aws-terraform-vpc-module.public_subnet_ids[0]
  route_table_id                                 = module.aws-terraform-vpc-module.public_rt_id[0]
  subnet_type                                    = "private"
  ebs_root_volume_size                           = var.ebs_root_volume_size
  visible_to_all_users                           = var.visible_to_all_users
  release_label                                  = var.release_label
  applications                                   = var.applications
  configurations_json                            = var.configurations_json
  core_instance_group_instance_type              = var.core_instance_group_instance_type
  core_instance_group_instance_count             = var.core_instance_group_instance_count
  core_instance_group_ebs_size                   = var.core_instance_group_ebs_size
  core_instance_group_ebs_type                   = var.core_instance_group_ebs_type
  core_instance_group_ebs_volumes_per_instance   = var.core_instance_group_ebs_volumes_per_instance
  master_instance_group_instance_type            = var.master_instance_group_instance_type
  master_instance_group_instance_count           = var.master_instance_group_instance_count
  master_instance_group_ebs_size                 = var.master_instance_group_ebs_size
  master_instance_group_ebs_type                 = var.master_instance_group_ebs_type
  master_instance_group_ebs_volumes_per_instance = var.master_instance_group_ebs_volumes_per_instance
  log_uri                                        = format("s3://%s", module.aws-terraform-s3-module.destination_s3_bucket_id)
  key_name                                       = var.key_pair_name
  tags                                           = var.tags
  pr_name = var.pr_name
}


#######################################################################################################################
/*VARIABLES FOR Lambda layer*/
#######################################################################################################################
module "aws-terraform-lambda-layers" {
  source = "./aws-terraform-lambda-layers"
  layer_name = var.layer_name

}
