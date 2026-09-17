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
