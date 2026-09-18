data "aws_ssm_parameter" "al2023_ami" {
  name = var.ami_ssm_parameter
}

data "aws_iam_policy_document" "runner_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "eks_describe_cluster" {
  statement {
    effect = "Allow"

    actions = [
      "eks:DescribeCluster"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "runner" {
  name               = "${var.name}-role"
  assume_role_policy = data.aws_iam_policy_document.runner_assume_role.json

  tags = {
    Name = "${var.name}-role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.runner.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "eks_describe_cluster" {
  name   = "${var.name}-eks-describe-cluster"
  role   = aws_iam_role.runner.id
  policy = data.aws_iam_policy_document.eks_describe_cluster.json
}

resource "aws_iam_instance_profile" "runner" {
  name = "${var.name}-profile"
  role = aws_iam_role.runner.name

  tags = {
    Name = "${var.name}-profile"
  }
}

resource "aws_security_group" "runner" {
  name        = "${var.name}-sg"
  description = "Security group for the CI GitHub Actions runner."
  vpc_id      = var.vpc_id

  egress {
    description = "Allow outbound HTTPS and other required outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_instance" "runner" {
  ami                         = data.aws_ssm_parameter.al2023_ami.value
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.runner.name
  vpc_security_group_ids      = [aws_security_group.runner.id]

  user_data = <<-EOF
    #!/bin/bash
    set -euo pipefail

    dnf update -y
    dnf install -y git jq unzip

    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
  EOF

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true
  }

  tags = {
    Name = var.name
  }

  depends_on = [
    aws_iam_role_policy_attachment.ssm
  ]
}
