resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"

  repository = "https://aws.github.io/eks-charts" 
  chart      = "aws-load-balancer-controller"

  values = [
    templatefile("${path.module}/values.yaml", {
      cluster_name = var.cluster_name
      aws_region   = var.aws_region
      vpc_id       = var.vpc_id
    })
  ]
}