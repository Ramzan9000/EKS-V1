variable "aws_region" {
  type        = string
  description = "AWS region for CI infrastructure."
}

variable "name" {
  type        = string
  description = "Name prefix for CI infrastructure."
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the CI VPC."
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet."
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for the private runner subnet."
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone for the CI VPC."
}
