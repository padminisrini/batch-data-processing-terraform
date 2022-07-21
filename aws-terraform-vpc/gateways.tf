resource "aws_internet_gateway" "igw" {
  count  = (length(var.public_subnet_cidrs) > 0) ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name  = "${var.pr_name}-IGW"
 }
}

resource "aws_eip" "nat_eip" {
  count  = (length(var.public_subnet_cidrs) > 0) ? 1 : 0
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gw" {
  count  = (length(var.public_subnet_cidrs) > 0) ? 1 : 0
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)

  # Associated with first public subnet
  subnet_id  = element(aws_subnet.public_subnet.*.id, count.index)
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name  = "${var.pr_name}-NAT"
  }
}