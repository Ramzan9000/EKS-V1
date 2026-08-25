variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role assumed by the EKS control plane."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs used by the EKS cluster for networking."
  type        = list(string)
}

variable "public_access_cidrs" {
  description = "CIDR blocks allowed to access the public EKS Kubernetes API endpoint."
  type        = list(string)
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used by EKS to encrypt Kubernetes Secrets."
  type        = string
}