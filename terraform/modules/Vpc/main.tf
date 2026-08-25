### VPC itself ###

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}


### public subnets ###

module "public_subnets" {
  source                  = "./submodules/public_subnets"
  vpc_id                  = aws_vpc.main.id
  public_subnet_az_1_cidr = var.public_subnet_az_1_cidr
  public_subnet_az_2_cidr = var.public_subnet_az_2_cidr
  availability_zone_1     = var.availability_zone_1
  availability_zone_2     = var.availability_zone_2

}


### private subnets ###

module "private_subnets" {
  source                   = "./submodules/private_subnets"
  vpc_id                   = aws_vpc.main.id
  private_subnet_az_1_cidr = var.private_subnet_az_1_cidr
  private_subnet_az_2_cidr = var.private_subnet_az_2_cidr
  availability_zone_1      = var.availability_zone_1
  availability_zone_2      = var.availability_zone_2
}

### internet gateway ###

module "internet_gateway" {
  source = "./submodules/internet_gateway"
  vpc_id = aws_vpc.main.id
}



### nat gateway ###




resource "aws_eip" "nat" {
  domain = "vpc"
}

### elastic ip created for nat to use allocation_id for oubound internet traffic ####


module "nat_gateway" {
  source        = "./submodules/nat_gateway"
  subnet_id     = module.public_subnets.public_subnet_ids[0]
  allocation_id = aws_eip.nat.id
}



### route tables ###


module "route_tables" {
  source             = "./submodules/route_tables"
  private_subnet_ids = module.private_subnets.private_subnet_ids
  public_subnet_ids  = module.public_subnets.public_subnet_ids
  vpc_id             = aws_vpc.main.id
  nat_id             = module.nat_gateway.nat_id
  igw_id             = module.internet_gateway.igw_id
}
