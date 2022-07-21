output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet.*.id
}

output "public_subnet_cidrs" {
  value = aws_subnet.public_subnet.*.cidr_block
}

output "private_subnet_cidrs" {
  value = aws_subnet.private_subnet.*.cidr_block
}

output "public_rt_id" {
  value = aws_route_table.public_rt.*.id
}

output "private_rt_id" {
  value = aws_route_table.private_rt.*.id
}

output "nat_gw_id" {
  value = aws_nat_gateway.nat_gw.*.id
}

output "aws_default_security_group" {
  value = "${aws_default_security_group.default.id}"
}