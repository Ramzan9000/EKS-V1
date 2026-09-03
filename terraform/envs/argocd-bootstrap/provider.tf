variable "environment" {
  type = string
}

data "terraform_remote_state" "cluster" {
  backend = "s3"

  config = {
    bucket = "my-tf-state-bucket-proj-new"
    key    = "envs/${var.environment}/terraform.tfstate"
    region = "eu-west-2"
  }
}

provider "kubernetes" {
  host = data.terraform_remote_state.cluster.outputs.cluster_endpoint

  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.cluster.outputs.cluster_certificate_authority_data
  )

  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"

    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.terraform_remote_state.cluster.outputs.cluster_name,
      "--region",
      "eu-west-2"
    ]
  }
}