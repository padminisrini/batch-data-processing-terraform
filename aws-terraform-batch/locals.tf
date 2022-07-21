locals {

  short_aws_region_list = try(split("-", var.aws_region), tomap({}))
  direction             = lookup(var.aws_region_map, local.short_aws_region_list[1], "e")
  short_aws_region      = join("", [local.short_aws_region_list[0], local.direction, local.short_aws_region_list[2]])
  infra_label           = var.infra_label != "" ? var.infra_label : join("-", [var.project_name, var.project_environment, local.short_aws_region])

  compute_environment_name         = join("-", [local.infra_label, "ce"])
  batch_job_queue_name             = join("-", [local.infra_label, "queue"])
  vpc_name                         = join("-", [local.infra_label, "vpc"])
  aws_batch_service_role_name      = join("-", [local.infra_label, "batch", "role"])
  task_execution_service_role_name = join("-", [local.infra_label, "batch", "task", "role"])
  vpc_id                           = var.vpc_id 
  private_subnets_ids              =  var.private_subnets 
  public_subnets_ids               = var.public_subnets
  vpc_cidr_block                   =  var.vpc_cidr 
  create = var.create_lambda
    create_role = local.create
  role_name = local.create_role ? coalesce(var.role_name, var.function_name, "*") : null
}
