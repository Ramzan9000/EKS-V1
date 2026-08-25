variable "cluster_name" {
  description = "Name of the EKS cluster where the managed node group will be created."
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS managed node group."
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the IAM role assumed by the EC2 worker nodes."
  type        = string
}

variable "subnet_ids" {
  description = "IDs of the private subnets where the EKS worker nodes will be placed."
  type        = list(string)
}

variable "instance_types" {
  description = "EC2 instance types available to the EKS worker nodes."
  type        = list(string)
}

variable "desired_size" {
  description = "Desired number of worker nodes in the managed node group."
  type        = number
}

variable "min_size" {
  description = "Minimum number of worker nodes in the managed node group."
  type        = number
}

variable "max_size" {
  description = "Maximum number of worker nodes in the managed node group."
  type        = number
}

variable "max_unavailable" {
  description = "Maximum number of worker nodes that can be unavailable during a managed node-group update."
  type        = number
}

variable "node_security_group_id" {
  description = "ID of the custom security group attached to the EKS worker nodes."
  type        = string
}