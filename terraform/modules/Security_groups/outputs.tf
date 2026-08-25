
output "node_security_group_id" {
  description = "ID of the security group created for the EKS worker nodes."
  value       = aws_security_group.node_group.id
}