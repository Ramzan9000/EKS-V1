

#role for eks cluster#


resource "aws_iam_role" "eks_cluster" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "eks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

#role and policy attachment for eks cluster#

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


#role for node-groups#

resource "aws_iam_role" "eks_node" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


#role and policies attachment for node-groups#


resource "aws_iam_role_policy_attachment" "eks_node_worker" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_ecr" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

#role for cni #

resource "aws_iam_role" "vpc_cni" {
  name = "${var.cluster_name}-vpc-cni-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowEksAuthToAssumeRoleForPodIdentity"
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}


#role and policy attachment for cni#

resource "aws_iam_role_policy_attachment" "vpc_cni" {
  role       = aws_iam_role.vpc_cni.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}



#role for cert manager#

resource "aws_iam_role" "cert_manager" {
  name = "${var.cluster_name}-cert-manager-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}



#policy for cert manager#

resource "aws_iam_policy" "cert_manager_route53" {
  name = "${var.cluster_name}-cert-manager-route53"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "route53:GetChange"
        ]

        Resource = "arn:aws:route53:::change/*"
      },
      {
        Effect = "Allow"

        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ]

        Resource = var.route53_hosted_zone_arn
      },
      {
        Effect = "Allow"

        Action = [
          "route53:ListHostedZonesByName"
        ]

        Resource = "*"
      }
    ]
  })
}


#role and policy attachment for cert manager#

resource "aws_iam_role_policy_attachment" "cert_manager_route53" {
  role       = aws_iam_role.cert_manager.name
  policy_arn = aws_iam_policy.cert_manager_route53.arn
}




#role for loki#


resource "aws_iam_role" "loki" {
  name = "${var.cluster_name}-loki-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}


# policy for loki #

resource "aws_iam_policy" "loki_s3" {
  name = "${var.cluster_name}-loki-s3"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = var.loki_bucket_arn
      },
      {
        Effect = "Allow"

        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]

        Resource = "${var.loki_bucket_arn}/*"
      }
    ]
  })
}

# role and policy attachment for loki #

resource "aws_iam_role_policy_attachment" "loki_s3" {
  role       = aws_iam_role.loki.name
  policy_arn = aws_iam_policy.loki_s3.arn
}





#role for aws load balancer controller#


resource "aws_iam_role" "aws_load_balancer_controller" { 

  name = "${var.cluster_name}-aws-load-balancer-controller-role" 

  

  assume_role_policy = jsonencode({ 

    Version = "2012-10-17" 

  

    Statement = [ 

      { 

        Sid    = "AllowEksAuthToAssumeRoleForPodIdentity" 

        Effect = "Allow" 

  

        Principal = { 

          Service = "pods.eks.amazonaws.com" 

        } 

  

        Action = [ 

          "sts:AssumeRole", 

          "sts:TagSession" 

        ] 

      } 

    ] 

  }) 

} 


# policy for aws load balancer controller #

resource "aws_iam_policy" "aws_load_balancer_controller" {
  name   = "${var.cluster_name}-AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/policies/aws_load_balancer_controller.json")
}


# role and policy attachment for aws load balancer controller #

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  role       = aws_iam_role.aws_load_balancer_controller.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}


# role for external dns

resource "aws_iam_role" "external_dns" {
  name = "${var.cluster_name}-external-dns-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowEksAuthToAssumeRoleForPodIdentity"
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

# policy for external dns

resource "aws_iam_policy" "external_dns_route53" {
  name = "${var.cluster_name}-external-dns-route53"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ]

        Resource = var.route53_hosted_zone_arn
      },
      {
        Effect = "Allow"

        Action = [
          "route53:ListHostedZonesByName"
        ]

        Resource = "*"
      }
    ]
  })
}

# role and policy attachment for external dns

resource "aws_iam_role_policy_attachment" "external_dns_route53" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.external_dns_route53.arn
}