resource "aws_security_group" "node_group" {
  name        = "${var.cluster_name}-node-group"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-node-group"
  }
}


# inbound rule for EKS control plane → worker nodes
resource "aws_vpc_security_group_ingress_rule" "node_from_cluster" {
  security_group_id            = aws_security_group.node_group.id
  referenced_security_group_id = var.cluster_security_group_id #get this from the output.tf of eks module#

  ip_protocol = "-1"
}


# inbound rule for  Worker node → Worker node
resource "aws_vpc_security_group_ingress_rule" "node_to_node" {
  security_group_id            = aws_security_group.node_group.id
  referenced_security_group_id = aws_security_group.node_group.id 

  ip_protocol = "-1"
}


# Outbound rulle for Worker nodes → anywhere
resource "aws_vpc_security_group_egress_rule" "node_outbound" {
  security_group_id = aws_security_group.node_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}