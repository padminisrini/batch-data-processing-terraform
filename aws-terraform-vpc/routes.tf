resource "aws_route_table" "public_rt" {
  count = (length(var.public_subnet_cidrs) > 0) ? 1 : 0

  vpc_id = aws_vpc.vpc.id

    tags = merge(var.tags,
    {
        "Name"  = "${var.pr_name}-Public-Route"
    }
  )
}

resource "aws_route" "public_route" {
  count                  = (length(var.public_subnet_cidrs) > 0) ? 1 : 0
  route_table_id         = aws_route_table.public_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[count.index].id
}

resource "aws_route_table_association" "public_subnet_rt_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.public_rt.*.id, count.index)
}

resource "aws_route_table" "private_rt" {
  count = (length(var.public_subnet_cidrs) > 0) ? 1 : 0

  vpc_id = aws_vpc.vpc.id

    tags = merge(var.tags,
    {
        "Name"  = "${var.pr_name}-Privare-Route"
    }
  )
}

resource "aws_route" "private_route" {
  count                  = (length(var.private_subnet_cidrs) > 0) ? 1 : 0
  route_table_id         = aws_route_table.private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gw[count.index].id
}

resource "aws_route_table_association" "private_subnet_rt_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_rt.*.id, count.index)
}