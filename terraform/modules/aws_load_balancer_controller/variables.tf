variable "cluster_name" {
  description = "Name of the EKS cluster where the AWS Load Balancer Controller is installed."
  type        = string
}

variable "aws_region" {
  description = "AWS region where the EKS cluster and load balancer resources are deployed."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC used by the EKS cluster and AWS Load Balancer Controller."
  type        = string
}