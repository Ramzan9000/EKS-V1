output "private_subnet_ids" {
  value       = [aws_subnet.private_az_1.id, aws_subnet.private_az_2.id]
  description = "List of private subnet IDs used for internal resources "
}