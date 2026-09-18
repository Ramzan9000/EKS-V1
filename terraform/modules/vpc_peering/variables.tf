variable "name" {
  type        = string
  description = "Name tag for the VPC peering connection."
}

variable "requester_vpc_id" {
  type        = string
  description = "Requester VPC ID."
}

variable "requester_vpc_cidr" {
  type        = string
  description = "CIDR block of the requester VPC."
}

variable "requester_route_table_ids" {
  type        = map(string)
  description = "Named route tables in the requester VPC that need peer access."
}

variable "accepter_vpc_id" {
  type        = string
  description = "Accepter VPC ID."
}

variable "accepter_vpc_cidr" {
  type        = string
  description = "CIDR block of the accepter VPC."
}

variable "accepter_route_table_ids" {
  type        = map(string)
  description = "Named route tables in the accepter VPC that need a return route."
}
