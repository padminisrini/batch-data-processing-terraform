resource "aws_batch_compute_environment" "compute_environment" {
  depends_on = [
    aws_iam_role.aws_batch_service_role,
    aws_security_group.batch_security,
    aws_iam_role_policy_attachment.aws_batch_service_role_policy,
    aws_iam_role_policy_attachment.aws_batch_service_role_policy_1,
    aws_iam_role_policy_attachment.aws_batch_service_role_policy_2,
    aws_iam_role_policy_attachment.aws_batch_service_role_policy_3,
    aws_iam_role_policy_attachment.aws_batch_service_role_policy_4,
    aws_iam_role_policy_attachment.aws_batch_service_role_policy_5,
    aws_iam_role_policy_attachment.aws_batch_service_role_policy_6,
    aws_iam_role_policy_attachment.aws_batch_service_role_policy_7,
    aws_iam_role_policy_attachment.aws_batch_service_role_policy_8,
    aws_iam_role_policy_attachment.aws_batch_service_role_policy_9
  ]
  compute_environment_name = local.compute_environment_name
  service_role             = aws_iam_role.aws_batch_service_role.arn
  type                     = "MANAGED"

  compute_resources {
    max_vcpus          = var.max_vcpus
    security_group_ids = [aws_security_group.batch_security.id]
    subnets            = var.private_subnet_ids
    type               = var.compute_resources_type
  }
}

resource "aws_batch_job_queue" "job_queue" {
  name                 = local.batch_job_queue_name
  state                = var.batch_job_queue_state
  priority             = var.batch_job_queue_priority
  compute_environments = [aws_batch_compute_environment.compute_environment.arn]
}


data "template_file" "container_properties" {
  count    = length(var.container_properties.job_definition)
  template = file("${path.module}/files/container_properties.json")
  vars = {
    container_command          = var.container_command
    container_image            = var.container_properties.job_definition[count.index].container_image
    fargate_platform_version   = var.container_properties.job_definition[count.index].fargate_platform_version
    container_vcpu             = var.container_properties.job_definition[count.index].container_vcpu
    container_memory           = var.container_properties.job_definition[count.index].container_memory
    container_executionRoleArn = aws_iam_role.task_execution_service_role.arn
    container_jobRoleArn       = aws_iam_role.task_execution_service_role.arn
  }
}

resource "aws_batch_job_definition" "job_definition" {
  count                 = length(var.container_properties.job_definition)
  name                  = var.container_properties.job_definition[count.index].name
  type                  = "container"
  container_properties  = data.template_file.container_properties[count.index].rendered
  platform_capabilities = ["FARGATE"]
}

resource "aws_security_group" "batch_security" {
  name        = ""
  description = "Allow all traffic within VPC"
  vpc_id      = local.vpc_id

  ingress {
    cidr_blocks = [local.vpc_cidr_block]
    description = "Allow all traffic within VPC"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
  }
}