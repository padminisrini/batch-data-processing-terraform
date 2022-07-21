resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.public_subnet_azs, count.index)
  map_public_ip_on_launch = "true"

    tags = merge(var.tags,
    {
        "Name"  = "${var.pr_name}-${var.public_subnet_name}-${count.index + 1}"
    }
  )
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.private_subnet_azs, count.index)

  tags = merge(var.tags,
    {
        "Name"  = "${var.pr_name}-${var.private_subnet_name}-${count.index + 1}"
    }
  )
}

