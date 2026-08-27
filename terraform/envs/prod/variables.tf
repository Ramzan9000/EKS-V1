### VPC module and submodules ###


variable "cidr_block" {
  type        = string
  description = "Cidr of the VPC"
}


variable "region" {
  type        = string
  description = "AWS region of deployment"
}

variable "private_subnet_az_1_cidr" {
  type        = string
  description = "Cidr for the first private VPC"
}


variable "private_subnet_az_2_cidr" {
  type        = string
  description = "Cidr for the second private VPC"
}


variable "public_subnet_az_1_cidr" {
  type        = string
  description = "Cidr block for the first public subnet"
}


variable "public_subnet_az_2_cidr" {
  type        = string
  description = "Cidr block for the second public subnet"
}

variable "availability_zone_1" {
  type        = string
  description = "First Availability Zone used for subnet deployment "
}

variable "availability_zone_2" {
  type        = string
  description = "Second Availability Zone used for subnet deployment "
}



### ECR module ###


variable "ecr_repo_name" {
  type        = string
  description = "name of ecr repo"
}


### iam,kms ###

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}


### s3 module  ###

variable "loki_bucket_name" {
  description = "Globally unique name for the S3 bucket used by Loki for log storage."
  type = string
}



### pod_identity module ###

variable "loki_namespace" {
  description = "Kubernetes namespace where Loki is deployed."
  type        = string
}

variable "loki_service_account" {
  description = "Kubernetes ServiceAccount name used by Loki for EKS Pod Identity."
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


### node-group module ###

variable "node_group_name" {
  description = "Name of the EKS managed node group."
  type        = string
}

variable "node_instance_types" {
  description = "EC2 instance types used by the EKS worker nodes."
  type        = list(string)
}

variable "node_desired_size" {
  description = "Desired number of EKS worker nodes."
  type        = number
}

variable "node_min_size" {
  description = "Minimum number of EKS worker nodes."
  type        = number
}

variable "node_max_size" {
  description = "Maximum number of EKS worker nodes."
  type        = number
}

variable "node_max_unavailable" {
  description = "Maximum number of worker nodes that can be unavailable during a node-group update."
  type        = number
}



### EKS module ###

variable "eks_public_access_cidrs" {
  description = "CIDR blocks allowed to access the public EKS Kubernetes API endpoint."
  type        = list(string)

}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
}

### aws_load_balancer_controller module ###


variable "aws_region" {
  description = "AWS region where the EKS cluster and load balancer resources are deployed."
  type        = string
}


