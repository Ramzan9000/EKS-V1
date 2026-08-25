
# for eks module #

output "eks_secrets_key_arn" {
  description = "ARN of the customer-managed KMS key used by EKS for Kubernetes API data encryption."
  value = aws_kms_key.eks.arn
}

# for possible later use #

output "eks_secrets_key_id" {
  description = "ID of the customer-managed KMS key used by EKS."
  value = aws_kms_key.eks.key_id
}