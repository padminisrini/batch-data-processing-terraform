data "aws_partition" "current" {}

resource "aws_security_group" "managed_master" {
  count                  = var.create_emr ? 1 : 0
  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id
  name                   = "managed master sg"
  description            = "EmrManagedMasterSecurityGroup"
  tags                   = var.tags

  # EMR will update "ingress" and "egress" so we ignore the changes here
  lifecycle {
    ignore_changes = [ingress, egress]
  }
}

resource "aws_security_group_rule" "managed_master_egress" {
  count             = var.create_emr ? 1 : 0
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = join("", aws_security_group.managed_master.*.id)
}

resource "aws_security_group" "managed_slave" {
  count                  = var.create_emr ? 1 : 0
  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id
  name                   = "manager slave sg"
  description            = "EmrManagedSlaveSecurityGroup"
  tags                   = var.tags

  # EMR will update "ingress" and "egress" so we ignore the changes here
  lifecycle {
    ignore_changes = [ingress, egress]
  }
}

resource "aws_security_group_rule" "managed_slave_egress" {
  count             = var.create_emr ? 1 : 0
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = join("", aws_security_group.managed_slave.*.id)
}

resource "aws_security_group" "managed_service_access" {
  count                  = var.create_emr ? 1 : 0
  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id
  name                   = "managed service sg"
  description            = "EmrManagedServiceAccessSecurityGroup"
  tags                   = var.tags

  # EMR will update "ingress" and "egress" so we ignore the changes here
  lifecycle {
    ignore_changes = [ingress, egress]
  }
}

resource "aws_security_group_rule" "managed_master_service_access_ingress" {
  count                    = var.create_emr ? 1 : 0
  description              = "Allow ingress traffic from EmrManagedMasterSecurityGroup"
  type                     = "ingress"
  from_port                = 9443
  to_port                  = 9443
  protocol                 = "tcp"
  source_security_group_id = join("", aws_security_group.managed_master.*.id)
  security_group_id        = join("", aws_security_group.managed_service_access.*.id)
}

resource "aws_security_group_rule" "managed_service_access_egress" {
  count             = var.create_emr ? 1 : 0
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = join("", aws_security_group.managed_service_access.*.id)
}

# Specify additional master and slave security groups
resource "aws_security_group" "master" {
  count                  = var.create_emr ? 1 : 0
  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id
  name                   = "master sg"
  description            = "Allow inbound traffic from Security Groups and CIDRs for masters. Allow all outbound traffic"
  tags                   = var.tags
}

resource "aws_security_group_rule" "master_ingress_security_groups" {
  count                    = var.create_emr ? 1 : 0
  description              = "Allow inbound traffic from Security Groups"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = var.master_allowed_security_groups[count.index]
  security_group_id        = join("", aws_security_group.master.*.id)
}

resource "aws_security_group_rule" "master_ingress_cidr_blocks" {
  count             = var.create_emr ? 1 : 0
  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["192.168.1.10/32"]#var.master_allowed_cidr_blocks
  security_group_id = join("", aws_security_group.master.*.id)
}

resource "aws_security_group_rule" "master_egress" {
  count             = var.create_emr ? 1 : 0
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.master.*.id)
}

resource "aws_security_group" "slave" {
  count                  = var.create_emr ? 1 : 0
  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id
  name                   = "slave sg"
  description            = "Allow inbound traffic from Security Groups and CIDRs for slaves. Allow all outbound traffic"
  tags                   = var.tags
}

resource "aws_security_group_rule" "slave_ingress_security_groups" {
  count                    = var.create_emr ? 1 : 0
  description              = "Allow inbound traffic from Security Groups"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = var.slave_allowed_security_groups[count.index]
  security_group_id        = join("", aws_security_group.slave.*.id)
}

resource "aws_security_group_rule" "slave_ingress_cidr_blocks" {
  count             = var.create_emr ? 1 : 0
  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["192.168.1.10/32"]
  security_group_id = join("", aws_security_group.slave.*.id)
}

resource "aws_security_group_rule" "slave_egress" {
  count             = var.create_emr ? 1 : 0
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.slave.*.id)
}

data "aws_iam_policy_document" "assume_role_emr" {
  count = var.create_emr ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["elasticmapreduce.amazonaws.com", "application-autoscaling.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "emr" {
  count                = var.create_emr ? 1 : 0
  name                 = "emr-role"
  assume_role_policy   = join("", data.aws_iam_policy_document.assume_role_emr.*.json)
  permissions_boundary = var.emr_role_permissions_boundary

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "emr" {
  count      = var.create_emr ? 1 : 0
  role       = join("", aws_iam_role.emr.*.name)
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

data "aws_iam_policy_document" "assume_role_ec2" {
  count = var.create_emr ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2" {
  count                = var.create_emr ? 1 : 0
  name                 = "emr-ec2-role"
  assume_role_policy   = join("", data.aws_iam_policy_document.assume_role_ec2.*.json)
  permissions_boundary = var.ec2_role_permissions_boundary

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ec2" {
  count      = var.create_emr ? 1 : 0
  role       = join("", aws_iam_role.ec2.*.name)
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2" {
  count = var.create_emr ? 1 : 0
  name  = join("", aws_iam_role.ec2.*.name)
  role  = join("", aws_iam_role.ec2.*.name)
  tags  = var.tags
}

resource "aws_iam_role" "ec2_autoscaling" {
  count                = var.create_emr ? 1 : 0
  name                 = "ec2-autoscalind-role"
  assume_role_policy   = join("", data.aws_iam_policy_document.assume_role_emr.*.json)
  permissions_boundary = var.ec2_autoscaling_role_permissions_boundary

  tags = var.tags
}

# https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-iam-roles.html
resource "aws_iam_role_policy_attachment" "ec2_autoscaling" {
  count      = var.create_emr ? 1 : 0
  role       = join("", aws_iam_role.ec2_autoscaling.*.name)
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonElasticMapReduceforAutoScalingRole"
}

locals {
  bootstrap_action = concat(
    [{
      path = "file:/bin/echo",
      name = "Dummy bootstrap action to prevent EMR cluster recreation when configuration_json has parameter javax.jdo.option.ConnectionPassword",
      args = [md5(jsonencode(var.configurations_json))]
    }],
    var.bootstrap_action
  )

  kerberos_attributes = {
    ad_domain_join_password              = var.kerberos_ad_domain_join_password
    ad_domain_join_user                  = var.kerberos_ad_domain_join_user
    cross_realm_trust_principal_password = var.kerberos_cross_realm_trust_principal_password
    kdc_admin_password                   = var.kerberos_kdc_admin_password
    realm                                = var.kerberos_realm
  }

}

resource "aws_emr_cluster" "default" {
  count         = var.create_emr ? 1 : 0
  name          = "emr-cluster"
  release_label = var.release_label

  ec2_attributes {
    key_name                          = var.key_name
    subnet_id                         = var.subnet_id
    emr_managed_master_security_group =  join("", aws_security_group.managed_master.*.id)
    emr_managed_slave_security_group  = join("", aws_security_group.managed_slave.*.id)
   # service_access_security_group     =  join("", aws_security_group.managed_service_access.*.id)
    instance_profile                  =  join("", aws_iam_instance_profile.ec2.*.arn)
    additional_master_security_groups = join("", aws_security_group.master.*.id)
    additional_slave_security_groups  = join("", aws_security_group.slave.*.id)
  }

  termination_protection            = var.termination_protection
  keep_job_flow_alive_when_no_steps = var.keep_job_flow_alive_when_no_steps
  step_concurrency_level            = var.step_concurrency_level
  ebs_root_volume_size              = var.ebs_root_volume_size
  custom_ami_id                     = var.custom_ami_id
  visible_to_all_users              = var.visible_to_all_users

  applications = var.applications

  core_instance_group {
    name           = "emr-core-instance-group"
    instance_type  = var.core_instance_group_instance_type
    instance_count = var.core_instance_group_instance_count

    ebs_config {
      size                 = var.core_instance_group_ebs_size
      type                 = var.core_instance_group_ebs_type
      iops                 = var.core_instance_group_ebs_iops
      volumes_per_instance = var.core_instance_group_ebs_volumes_per_instance
    }

    bid_price          = var.core_instance_group_bid_price
    autoscaling_policy = var.core_instance_group_autoscaling_policy
  }

  master_instance_group {
    name           = "master-instance"
    instance_type  = var.master_instance_group_instance_type
    instance_count = var.master_instance_group_instance_count
    bid_price      = var.master_instance_group_bid_price

    ebs_config {
      size                 = var.master_instance_group_ebs_size
      type                 = var.master_instance_group_ebs_type
      iops                 = var.master_instance_group_ebs_iops
      volumes_per_instance = var.master_instance_group_ebs_volumes_per_instance
    }
  }

  scale_down_behavior    = var.scale_down_behavior
  additional_info        = var.additional_info
  security_configuration = var.security_configuration
  configurations_json = var.configurations_json

  log_uri = var.log_uri

  service_role     = join("", aws_iam_role.emr.*.arn)
  autoscaling_role = join("", aws_iam_role.ec2_autoscaling.*.arn)

  tags = var.tags

  # configurations_json changes are ignored because of terraform bug. Configuration changes are applied via local.bootstrap_action.
  lifecycle {
    ignore_changes = [kerberos_attributes, step, configurations_json]
  }
}
