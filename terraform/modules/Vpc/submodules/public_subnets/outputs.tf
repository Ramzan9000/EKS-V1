output "public_subnet_ids" {
  value       = [aws_subnet.public_az_1.id, aws_subnet.public_az_2.id]
  description = "List of public subnet IDs across two availability zones used for external resources "
}