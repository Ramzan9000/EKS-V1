# ============================================================
# AWS
# ============================================================

aws_region = "eu-west-2"


# ============================================================
# VPC
# ============================================================

cidr_block = "10.0.0.0/16"

availability_zone_1 = "eu-west-2a"
availability_zone_2 = "eu-west-2b"

public_subnet_az_1_cidr = "10.0.1.0/24"
public_subnet_az_2_cidr = "10.0.2.0/24"

private_subnet_az_1_cidr = "10.0.11.0/24"
private_subnet_az_2_cidr = "10.0.12.0/24"


# ============================================================
# EKS
# ============================================================

cluster_name = "eks-v1-dev"

kubernetes_version = "1.36"

eks_public_access_cidrs = [
  "151.226.76.8/32"
]


# ============================================================
# ECR
# ============================================================

ecr_repo_name = "eks-2048"


# ============================================================
# Node Group
# ============================================================

node_group_name = "eks-v1-dev-ng"

node_instance_types = [
  "t3.medium"
]

node_desired_size = 2
node_min_size     = 1
node_max_size     = 3

node_max_unavailable = 1


# ============================================================
# Loki / S3
# ============================================================

loki_bucket_name = "eks-v1-dev-loki-logs"

loki_namespace = "logging"       #check this and the service account matches the helm charts ones values#

loki_service_account = "loki"


#============================================================
# External DNS
# ============================================================

external_dns_namespace = "external-dns"
external_dns_service_account = "external-dns"