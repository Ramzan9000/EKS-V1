aws_region = "eu-west-2"

name = "eks-v1-ci"

# Must not overlap with the existing EKS VPC (10.0.0.0/16).
cidr_block = "10.20.0.0/16"

availability_zone = "eu-west-2a"

public_subnet_cidr  = "10.20.1.0/24"
private_subnet_cidr = "10.20.11.0/24"
