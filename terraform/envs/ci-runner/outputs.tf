output "ci_vpc_id" {
  value       = module.ci_vpc.vpc_id
  description = "CI VPC ID."
}

output "ci_vpc_cidr_block" {
  value       = module.ci_vpc.vpc_cidr_block
  description = "CI VPC CIDR block."
}

output "ci_private_subnet_id" {
  value       = module.ci_vpc.private_subnet_id
  description = "Private subnet ID for the CI runner."
}
