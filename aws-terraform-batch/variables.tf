variable "container_properties" {
  description = "container properties required in job defination"
  type = object({
    container_environment = list(list(map(any)))
    job_definition        = list(map(any))
  })
}

variable "max_vcpus" {
  type        = number
  default     = 20
  description = "The maximum number of EC2 vCPUs that an environment can reach."
}

variable "container_command" {
  type = string

}

variable "compute_resources_type" {
  type        = string
  default     = "FARGATE"
  description = "FARGATE_SPOT or FARGATE"
  validation {
    condition     = var.compute_resources_type == "FARGATE" || var.compute_resources_type == "FARGATE_SPOT"
    error_message = "The Compute resource type must be on of: 'FARGATE' or 'FARGATE_SPOT'."
  }
}

variable "batch_job_queue_state" {
  type        = string
  description = "The state of the job queue. Must be one of: ENABLED or DISABLED"
  default     = "ENABLED"
  validation {
    condition     = var.batch_job_queue_state == "ENABLED" || var.batch_job_queue_state == "DISABLED"
    error_message = "The state of the job queue Must be one of: ENABLED or DISABLED."
  }
}


variable "batch_job_queue_priority" {
  type        = number
  description = "The priority of the job queue. Job queues with a higher priority are evaluated first when associated with the same compute environment."
  default     = 1
}

variable "project_name" {
  type        = string
  description = "project name"
  default     = "demo"
}

variable "aws_region" {
  type        = string
  description = "aws region"
  default     = "us-east-2"
}

variable "project_environment" {
  type        = string
  description = "project environment"
  default     = "dev"
}


variable "aws_batch_service_role_policies" {
  type        = list(any)
  description = "List of aws managed policy to attached"
  default = [
    "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
  ]
}


variable "task_execution_service_role_policies" {
  type        = list(any)
  description = "List of aws managed policy to attached"
  default = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

variable "infra_label" {
  type        = string
  description = "Infrastructre labelling to identify the aws resources"
  default     = ""
}

variable "dynamodb_table_name" {
  type        = string
  description = "Dynamo db table name"
  default     = ""
}

variable "bucketName" {
  type        = string
  description = "Bucket name"
  default     = ""
}

variable "inputFileName" {
  type        = string
  description = "Bucket name"
  default     = ""
}

variable "region" {
  type        = string
  description = "Bucket name"
  default     = ""
}


variable "bucket_key" {
  type        = string
  description = "Bucket name"
  default     = ""
}

variable "job_command" {
  type        = list(string)
  description = "name of batch"
  default     = []
}

# If you want to create new VPC use vpc_cidr,private_subnets_cidrs, public_subnets_cidrs variables
variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC cidrs"
}

variable "private_subnets_cidrs" {
  type        = list(any)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "private subnets cidrs"
}
variable "public_subnets_cidrs" {
  type        = list(any)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  description = "public subnets cidrs"
}


# If you want to use existing VPC then provide vpc_id, private_subnets, public_subnets
variable "vpc_id" {
  default     = ""
  description = "VPC id (optional)"
}

variable "private_subnets" {
  type        = list(any)
  default     = []
  description = "Private Subnet Id's"
}

variable "public_subnets" {
  type        = list(any)
  default     = []
  description = "Public Subnet Id's"
}

variable "aws_region_map" {
  type = map(any)
  default = {
    "west"      = "w"
    "east"      = "e"
    "south"     = "s"
    "north"     = "n"
    "central"   = "c"
    "southeast" = "se"
    "northeast" = "ne"
  }
}

#lambda


variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string
}


variable "role_name" {
  description = "A unique name for your Lambda Function"
  type        = string
}

variable "handler" {
  description = "Lambda Function entrypoint in your code"
  type        = string
}

variable "runtime" {
  description = "Lambda Function runtime"
  type        = string
}

variable "description" {
  description = "Description of your Lambda Function (or Layer)"
  type        = string
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments."
  type        = number
  default     = 128
}


variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

variable "create_lambda" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}


variable "batch_secuity_groups" {
  description = " Securitu groups"
}

variable "private_subnet_ids" {
  description = "private subnets"
}

#tagging

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "pr_name" {
  type = string
}
