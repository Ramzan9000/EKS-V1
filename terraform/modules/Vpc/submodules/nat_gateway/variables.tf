variable "subnet_id" {
  type        = string
  description = "ID of the public subnet where the NAT Gateway will be created"
}


variable "allocation_id" {
  type        = string
  description = "Allocation ID of the Elastic IP attached to the NAT Gateway"
}