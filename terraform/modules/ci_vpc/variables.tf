variable "name" {
  type        = string
  description = "Name prefix for CI VPC resources."
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the CI VPC."
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet containing the NAT gateway."
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for the private subnet containing the CI runner."
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone for the CI VPC subnets."
}
