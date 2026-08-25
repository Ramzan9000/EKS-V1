

output "vpc_id" {
  description = "ID of the VPC used by the EKS cluster and worker nodes."
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs where EKS worker nodes are deployed."
  value       = module.private_subnets.private_subnet_ids
}

output "public_subnet_ids" {
  description = "List of public subnet IDs available for internet-facing AWS resources."
  value       = module.public_subnets.public_subnet_ids
}

output "cidr_ipv4" {
  description = "IPv4 CIDR block of the VPC."
  value       = aws_vpc.main.cidr_block
}

output "cidr_ipv6" {
  description = "IPv6 CIDR block of the VPC."
  value       = aws_vpc.main.ipv6_cidr_block
}

output "igw_id" {
  description = "ID of the internet gateway attached to the VPC."
  value       = module.internet_gateway.igw_id
}

output "nat_id" {
  description = "ID of the NAT gateway used for outbound internet access from private subnets."
  value       = module.nat_gateway.nat_id
}

output "allocation_id" {
  description = "Allocation ID of the Elastic IP associated with the NAT gateway."
  value       = aws_eip.nat.id
}