 resource "aws_eks_cluster" "this" {

  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.public_access_cidrs # our ip but for secruity idk if i should our specifc one to values yaml because when the project is in my repo cant everyone see my ip then #
  }

  encryption_config {
    provider {
      key_arn = var.kms_key_arn
    }

    resources = ["secrets"]
  }
}


#pod identity add-on#

resource "aws_eks_addon" "pod_identity_agent" {

  cluster_name = aws_eks_cluster.this.name
  addon_name   = "eks-pod-identity-agent"

  depends_on = [
    aws_eks_cluster.this
  ]
}

#VPC CNI add-on#

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "vpc-cni"

  depends_on = [
    aws_eks_cluster.this
  ]
}