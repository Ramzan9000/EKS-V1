output "instance_id" {
  description = "EC2 instance ID of the CI runner."
  value       = aws_instance.runner.id
}

output "private_ip" {
  description = "Private IP address of the CI runner."
  value       = aws_instance.runner.private_ip
}

output "security_group_id" {
  description = "Security group ID of the CI runner."
  value       = aws_security_group.runner.id
}

output "iam_role_arn" {
  description = "IAM role ARN attached to the CI runner."
  value       = aws_iam_role.runner.arn
}
