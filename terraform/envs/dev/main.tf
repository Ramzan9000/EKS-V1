### vpc module ###

module "vpc" {
  source = "../../modules/vpc"

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
  source        = "../../modules/ecr"
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

### iam module ###

module "iam" {
  source = "../../modules/iam"

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

  loki_role_arn = module.iam.loki_role_arn

  loki_namespace = var.loki_namespace

  loki_service_account = var.loki_service_account

  depends_on = [
    module.eks,
    module.iam
  ]
}


### security_group module ###

module "security_groups" {
  source = "../../modules/security_groups"

  cluster_name = var.cluster_name

  vpc_id = module.vpc.vpc_id

  cluster_security_group_id = module.eks.cluster_security_group_id
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

  node_security_group_id = module.security_groups.node_security_group_id

  depends_on = [
    module.eks,
    module.iam,
    module.security_groups
  ]
}


### EKS module ###

module "eks" {
  source = "../../modules/eks"

  cluster_name        = var.cluster_name
  cluster_role_arn    = module.iam.eks_cluster_role_arn
  kubernetes_version  = var.kubernetes_version

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

### aws_load_balancer_controller module ###

module "aws_load_balancer_controller" {
  source = "../../modules/aws_load_balancer_controller"

  cluster_name = module.eks.cluster_name
  aws_region   = var.aws_region
  vpc_id       = module.vpc.vpc_id

  depends_on = [
    module.eks,
    module.pod_identity
  ]
}

### argocd module ###

module "argocd" {
  source = "../../modules/argocd"

  depends_on = [
    module.eks
  ]
}
