variable "cluster_name" {
  description = "Name of the EKS cluster where the Pod Identity associations are created."
  type        = string
}

variable "vpc_cni_role_arn" {
  description = "ARN of the IAM role assigned to the Amazon VPC CNI aws-node ServiceAccount."
  type        = string
}

variable "aws_load_balancer_controller_role_arn" {
  description = "ARN of the IAM role assigned to the AWS Load Balancer Controller ServiceAccount."
  type        = string
}

variable "cert_manager_role_arn" {
  description = "ARN of the IAM role assigned to the cert-manager ServiceAccount."
  type        = string
}

variable "cert_manager_namespace" {
  description = "Kubernetes namespace in which the cert_manager ServiceAccount is deployed."
  type        = string
}

variable "cert_manager_service_account" {
  description = "Name of the Kubernetes ServiceAccount used by cert_manager."
  type        = string
}

variable "loki_role_arn" {
  description = "ARN of the IAM role assigned to the Loki ServiceAccount."
  type        = string
}

variable "loki_namespace" {
  description = "Kubernetes namespace in which the Loki ServiceAccount is deployed."
  type        = string
}

variable "loki_service_account" {
  description = "Name of the Kubernetes ServiceAccount used by Loki."
  type        = string
}

variable "external_dns_role_arn" {
  description = "IAM role ARN for ExternalDNS"
  type        = string
}

variable "external_dns_namespace" {
  description = "Kubernetes namespace where ExternalDNS is deployed"
  type        = string
}

variable "external_dns_service_account" {
  description = "Kubernetes service account used by ExternalDNS"
  type        = string
}