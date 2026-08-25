resource "aws_kms_key" "eks" {
  description             = "KMS key for EKS Kubernetes Secrets encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  tags = {
    Name = "${var.cluster_name}-eks-secrets"
  }
}

resource "aws_kms_alias" "eks" {
  name          = "alias/${var.cluster_name}-eks-secrets"
  target_key_id = aws_kms_key.eks.key_id
}