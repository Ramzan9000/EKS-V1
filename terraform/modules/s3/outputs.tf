output "loki_bucket_arn" {
  description = "ARN of the S3 bucket used by Loki for log storage."
  value       = aws_s3_bucket.loki.arn
}

output "loki_bucket_name" {
  description = "Name of the S3 bucket used by Loki for log storage."
  value       = aws_s3_bucket.loki.id
}