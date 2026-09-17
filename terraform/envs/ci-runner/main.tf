module "ci_vpc" {
  source = "../../modules/ci_vpc"

  name                = var.name
  cidr_block          = var.cidr_block
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
}

module "ci_runner" {
  source = "../../modules/ci_runner"

  name      = "${var.name}-runner"
  vpc_id    = module.ci_vpc.vpc_id
  subnet_id = module.ci_vpc.private_subnet_id

  depends_on = [module.ci_vpc]
}

data "aws_vpc" "eks" {
  filter {
    name   = "cidr-block"
    values = [var.eks_vpc_cidr]
  }
}

data "aws_route_tables" "eks" {
  vpc_id = data.aws_vpc.eks.id
}

module "vpc_peering" {
  source = "../../modules/vpc_peering"

  name = "${var.name}-to-eks"

  requester_vpc_id         = module.ci_vpc.vpc_id
  requester_vpc_cidr       = module.ci_vpc.vpc_cidr_block
  requester_route_table_id = module.ci_vpc.private_route_table_id

  accepter_vpc_id          = data.aws_vpc.eks.id
  accepter_vpc_cidr        = data.aws_vpc.eks.cidr_block
  accepter_route_table_ids = toset(data.aws_route_tables.eks.ids)

  depends_on = [
    module.ci_runner
  ]
}
