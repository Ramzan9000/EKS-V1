variable "cidr_block" {
  type        = string
  description = "Cidr of the VPC"
}

variable "private_subnet_az_1_cidr" {
  type        = string
  description = "Cidr for the first private VPC"
}


variable "private_subnet_az_2_cidr" {
  type        = string
  description = "Cidr for the second private VPC"
}


variable "public_subnet_az_1_cidr" {
  type        = string
  description = "Cidr block for the first public subnet"
}


variable "public_subnet_az_2_cidr" {
  type        = string
  description = "Cidr block for the second public subnet"
}

variable "availability_zone_1" {
  type        = string
  description = "First Availability Zone used for subnet deployment "
}

variable "availability_zone_2" {
  type        = string
  description = "Second Availability Zone used for subnet deployment "
}