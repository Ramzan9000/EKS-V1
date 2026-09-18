### vpc module ###

module "vpc" {
  source = "../../modules/Vpc"

  cidr_block               = var.cidr_block
  public_subnet_az_1_cidr  = var.public_subnet_az_1_cidr
  public_subnet_az_2_cidr  = var.public_subnet_az_2_cidr
  private_subnet_az_1_cidr = var.private_subnet_az_1_cidr
  private_subnet_az_2_cidr = var.private_subnet_az_2_cidr
  availability_zone_1      = var.availability_zone_1
  availability_zone_2      = var.availability_zone_2
}


### ECR module ###

module "ecr" {
  source        = "../../modules/ECR"
  ecr_repo_name = var.ecr_repo_name

}

#add the data source part here i think for route 53 dns folder fix the one hers key and stuff to make it correct#

data "terraform_remote_state" "dns" {
  backend = "s3"

  config = {
    bucket = "my-tf-state-bucket-proj-new"
    key    = "envs/dns/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "ci_runner" {
  backend = "s3"

  config = {
    bucket = "my-tf-state-bucket-proj-new"
    key    = "envs/ci-runner/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "aws_route_table" "eks_private_1" {
  subnet_id = module.vpc.private_subnet_ids[0]
}

data "aws_route_table" "eks_private_2" {
  subnet_id = module.vpc.private_subnet_ids[1]
}

### iam module ###

module "iam" {
  source = "../../modules/IAM"

  cluster_name = var.cluster_name

  route53_hosted_zone_arn = data.terraform_remote_state.dns.outputs.zone_arn

  loki_bucket_arn = module.s3.loki_bucket_arn
}

### kms module  ###

module "kms" {
  source = "../../modules/kms"

  cluster_name = var.cluster_name
}


### s3 module  ###

module "s3" {
  source = "../../modules/s3"

  bucket_name = var.loki_bucket_name
}


### pod_identity module ###

module "pod_identity" {
  source = "../../modules/pod_identity"

  cluster_name = module.eks.cluster_name

  vpc_cni_role_arn = module.iam.vpc_cni_role_arn

  aws_load_balancer_controller_role_arn = module.iam.aws_load_balancer_controller_role_arn

  cert_manager_role_arn = module.iam.cert_manager_role_arn

  cert_manager_namespace = var.cert_manager_namespace

  cert_manager_service_account = var.cert_manager_service_account

  external_dns_role_arn = module.iam.external_dns_role_arn

  external_dns_namespace = var.external_dns_namespace

  external_dns_service_account = var.external_dns_service_account

  loki_role_arn = module.iam.loki_role_arn

  loki_namespace = var.loki_namespace

  loki_service_account = var.loki_service_account

  depends_on = [
    module.eks,
    module.iam
  ]
}


### node-group module ###

module "node_groups" {
  source = "../../modules/node_groups"

  cluster_name    = module.eks.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = module.iam.eks_node_role_arn

  subnet_ids = module.vpc.private_subnet_ids

  instance_types = var.node_instance_types

  desired_size = var.node_desired_size
  min_size     = var.node_min_size
  max_size     = var.node_max_size

  max_unavailable = var.node_max_unavailable

  depends_on = [
    module.eks,
    module.iam
  ]
}


### EKS module ###

module "eks" {
  source = "../../modules/EKS"

  cluster_name       = var.cluster_name
  cluster_role_arn   = module.iam.eks_cluster_role_arn
  kubernetes_version = var.kubernetes_version

  subnet_ids = concat(
    module.vpc.public_subnet_ids,
    module.vpc.private_subnet_ids
  )

  public_access_cidrs = var.eks_public_access_cidrs

  kms_key_arn = module.kms.eks_secrets_key_arn

  depends_on = [
    module.iam,
    module.kms
  ]
}

### CI runner to EKS VPC peering ###

module "vpc_peering" {
  source = "../../modules/vpc_peering"

  name = "eks-v1-ci-to-eks"

  requester_vpc_id   = module.vpc.vpc_id
  requester_vpc_cidr = module.vpc.cidr_ipv4
  requester_route_table_ids = toset([
    data.aws_route_table.eks_private_1.id,
    data.aws_route_table.eks_private_2.id
  ])

  accepter_vpc_id   = data.terraform_remote_state.ci_runner.outputs.ci_vpc_id
  accepter_vpc_cidr = data.terraform_remote_state.ci_runner.outputs.ci_vpc_cidr_block
  accepter_route_table_ids = toset([
    data.terraform_remote_state.ci_runner.outputs.ci_private_route_table_id
  ])
}

### aws_load_balancer_controller module ###

module "aws_load_balancer_controller" {
  source = "../../modules/aws_load_balancer_controller"

  cluster_name = module.eks.cluster_name
  aws_region   = var.aws_region
  vpc_id       = module.vpc.vpc_id

  depends_on = [
    module.eks,
    module.node_groups,
    module.pod_identity
  ]
}

### argocd module ###

module "argocd" {
  source = "../../modules/argocd"

  depends_on = [
    module.eks,
    module.node_groups
  ]
}

data "aws_security_group" "eks_cluster" {
  filter {
    name   = "tag:aws:eks:cluster-name"
    values = [var.cluster_name]
  }

  depends_on = [module.eks]
}

resource "aws_vpc_security_group_ingress_rule" "ci_runner_to_eks_api" {
  security_group_id = data.aws_security_group.eks_cluster.id

  cidr_ipv4   = var.ci_runner_subnet_cidr
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443

  description = "Allow the private CI runner subnet to reach the EKS Kubernetes API."
}
