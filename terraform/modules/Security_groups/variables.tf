variable "cluster_name" {
  description = "Name of the EKS cluster used to name the worker-node security group."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS worker-node security group will be created."
  type        = string
}

variable "cluster_security_group_id" {
  description = "ID of the EKS cluster security group used as the trusted source for control-plane traffic to worker nodes."
  type        = string
}