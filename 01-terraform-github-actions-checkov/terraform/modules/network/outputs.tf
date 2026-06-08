output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "igw_id" {
  value = aws_internet_gateway.main.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.main.id
}

