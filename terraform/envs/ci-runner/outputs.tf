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

output "ci_private_route_table_id" {
  value       = module.ci_vpc.private_route_table_id
  description = "Private route table ID used by the CI runner subnet."
}

output "ci_runner_instance_id" {
  value       = module.ci_runner.instance_id
  description = "CI runner EC2 instance ID."
}

output "ci_runner_private_ip" {
  value       = module.ci_runner.private_ip
  description = "Private IP address of the CI runner."
}

output "ci_runner_security_group_id" {
  value       = module.ci_runner.security_group_id
  description = "Security group ID of the CI runner."
}
