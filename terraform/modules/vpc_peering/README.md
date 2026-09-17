# VPC Peering

Creates a same-account, same-region VPC peering connection and the routes required for private communication between two VPCs.

The module also enables DNS resolution across the peering connection.

It intentionally accepts route table IDs instead of creating or owning the VPC route tables themselves.
