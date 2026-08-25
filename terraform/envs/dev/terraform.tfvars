# cidr_block = "10.0.0.0/16"#
# region     = "eu-west-2"

# public_subnet_az_1_cidr  = "10.0.1.0/24"
# public_subnet_az_2_cidr  = "10.0.2.0/24"
# private_subnet_az_1_cidr = "10.0.3.0/24"
# private_subnet_az_2_cidr = "10.0.4.0/24"

# availability_zone_1 = "eu-west-2a"
# availability_zone_2 = "eu-west-2b"#

# =========================================================
# AWS
# =========================================================

aws_region = "eu-west-2"


# =========================================================
# VPC
# =========================================================

cidr_block = "10.0.0.0/16"

public_subnet_az_1_cidr = "10.0.1.0/24"
public_subnet_az_2_cidr = "10.0.2.0/24"

private_subnet_az_1_cidr = "10.0.11.0/24"
private_subnet_az_2_cidr = "10.0.12.0/24"

availability_zone_1 = "eu-west-2a"
availability_zone_2 = "eu-west-2b"


# =========================================================
# EKS
# =========================================================

# 🚨 PROJECT-SPECIFIC: change this to your preferred name.
cluster_name = "test-eks"

# 1.35 is currently under standard EKS support.
kubernetes_version = "1.35"

# TEST VALUE FOR PLAN ONLY.
# 203.0.113.0/24 is a documentation-only IP range.
# Replace with YOUR.PUBLIC.IP/32 before an actual apply.
eks_public_access_cidrs = ["203.0.113.10/32"]


# =========================================================
# ECR
# =========================================================

# 🚨 PROJECT-SPECIFIC: choose your real repository name later.
ecr_repo_name = "test-eks-application"


# =========================================================
# Loki S3
# =========================================================

# 🚨 PROJECT-SPECIFIC: must be globally unique for a real apply.
loki_bucket_name = "test-eks-loki-logs-change-me"


# =========================================================
# Loki Pod Identity
# =========================================================

# 🚨 Confirm these against your Loki Helm configuration later.
loki_namespace       = "loki"
loki_service_account = "loki"


# =========================================================
# EKS Node Group
# =========================================================

# 🚨 PROJECT-SPECIFIC: change later if you want a different name.
node_group_name = "test-eks-workers"

# t3.small is a sensible small test node.
node_instance_types = ["t3.small"]

# Keep the test cluster to one worker.
node_desired_size = 1
node_min_size     = 1
node_max_size     = 1

node_max_unavailable = 1