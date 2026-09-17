variable "name" {
  type        = string
  description = "Name prefix for the CI runner resources."
}

variable "vpc_id" {
  type        = string
  description = "ID of the CI VPC."
}

variable "subnet_id" {
  type        = string
  description = "Private subnet ID for the CI runner."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the CI runner."
  default     = "t3.small"
}

variable "ami_ssm_parameter" {
  type        = string
  description = "SSM parameter containing the AMI ID to use for the runner."
  default     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

variable "root_volume_size" {
  type        = number
  description = "Root EBS volume size in GiB."
  default     = 30
}
