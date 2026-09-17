output "vpc_id" {
  description = "ID of the CI VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the CI VPC."
  value       = aws_vpc.this.cidr_block
}

output "private_subnet_id" {
  description = "Private subnet ID for the CI runner."
  value       = aws_subnet.private.id
}

output "public_subnet_id" {
  description = "Public subnet ID containing the NAT gateway."
  value       = aws_subnet.public.id
}

output "private_route_table_id" {
  description = "Private route table ID for the CI runner."
  value       = aws_route_table.private.id
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = aws_route_table.public.id
}

output "nat_gateway_id" {
  description = "NAT gateway ID."
  value       = aws_nat_gateway.this.id
}
