variable "private_subnet_az_1_cidr" {
  type        = string
  description = "Cidr for the first private VPC"
}


variable "private_subnet_az_2_cidr" {
  type        = string
  description = "Cidr for the second private VPC"
}


variable "vpc_id" {
  type        = string
  description = " "
}


variable "availability_zone_1" {
  type        = string
  description = "First Availability Zone used for subnet deployment "
}


variable "availability_zone_2" {
  type        = string
  description = "Second Availability Zone used for subnet deployment "
}