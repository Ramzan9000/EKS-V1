
# cni pod pod_identity_association #

resource "aws_eks_pod_identity_association" "vpc_cni" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "aws-node"
  role_arn        = var.vpc_cni_role_arn
}

# aws load balancer pod_identity_association #

resource "aws_eks_pod_identity_association" "aws_load_balancer_controller" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = var.aws_load_balancer_controller_role_arn
}


#  cert manager pod_identity_association #

resource "aws_eks_pod_identity_association" "cert_manager" {
  cluster_name    = var.cluster_name
  namespace       = "cert-manager"
  service_account = "cert-manager"
  role_arn        = var.cert_manager_role_arn
}


# loki pod_identity_association #

resource "aws_eks_pod_identity_association" "loki" {
  cluster_name    = var.cluster_name
  namespace       = var.loki_namespace
  service_account = var.loki_service_account
  role_arn        = var.loki_role_arn
}

