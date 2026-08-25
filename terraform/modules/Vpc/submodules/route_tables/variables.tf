variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs associated with the private route table"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs associated with the public route table"
}


variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the route tables are created"
}


variable "nat_id" {
  type        = string
  description = " ID of the NAT Gateway used by the private route table. "
}


variable "igw_id" {
  type        = string
  description = "ID of the Internet Gateway used by the public route table"
}