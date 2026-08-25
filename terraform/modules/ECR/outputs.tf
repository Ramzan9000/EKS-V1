output "repository_url" {
  description = "URL of the Amazon ECR repository used to push and pull container images."
  value       = aws_ecr_repository.main.repository_url
}

output "repository_arn" {
  description = "ARN of the Amazon ECR repository."
  value       = aws_ecr_repository.main.arn
}