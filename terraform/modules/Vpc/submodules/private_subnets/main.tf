
resource "aws_subnet" "private_az_1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_az_1_cidr
  availability_zone = var.availability_zone_1
}


resource "aws_subnet" "private_az_2" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_az_2_cidr
  availability_zone = var.availability_zone_2
}
