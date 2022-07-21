# CIDR for VPC
variable "vpc_cidr" {
  type = string
}

variable "public_subnet_name" {
  type = string
}

variable "private_subnet_name" {
  type = string
}

# CIDRs for public subnets
variable "public_subnet_cidrs" {
  type = list(string)
}

# CIDRs for private subnets
variable "private_subnet_cidrs" {
  type = list(string)
}


# Public Subnet AZs
variable "public_subnet_azs" {
  type = list(string)
}

# Private Subnet AZs
variable "private_subnet_azs" {
  type = list(string)
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "pr_name" {
  type = string
}

