
output "zone_id" {
  value = aws_route53_zone.primary.zone_id
}

output "name_servers" {
  value = aws_route53_zone.primary.name_servers
}


output "zone_arn" {
  description = "ARN of the Route 53 hosted zone."
  value       = aws_route53_zone.primary.arn
}