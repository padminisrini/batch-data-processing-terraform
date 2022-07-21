#Main VPC Resource
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  
  tags = merge(var.tags,
    {
        "Name" = "${var.pr_name}-VPC"
    }
  )
}
resource "aws_default_security_group" "default" {

  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags,
    {
        "Name" = "${var.pr_name}-VPC"
    }
  )
}