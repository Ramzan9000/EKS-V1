terraform {
  backend "s3" {
    bucket         = "my-tf-state-bucket-proj-new"
    key            = "envs/dev/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform_dynamodb_table_1"
    encrypt        = true
  }
}