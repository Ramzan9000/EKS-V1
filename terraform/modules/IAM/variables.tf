variable "cluster_name" {
  description = "Name of the EKS cluster used to name IAM roles and policies."
  type        = string
}

variable "route53_hosted_zone_arn" {
  description = "ARN of the Route 53 hosted zone that cert-manager is allowed to manage for DNS-01 certificate challenges."
  type        = string
}

variable "loki_bucket_arn" {
  description = "ARN of the S3 bucket that Loki is allowed to use for log storage."
  type        = string
}