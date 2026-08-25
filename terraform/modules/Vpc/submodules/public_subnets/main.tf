resource "aws_subnet" "public_az_1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_az_1_cidr
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true

}


resource "aws_subnet" "public_az_2" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_az_2_cidr
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

}