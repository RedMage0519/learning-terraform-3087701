variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t3.micro"
}

data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat_*-x86-64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"]  # Bitnami
}

type = object({
  name = string
  owner = string
})

default

module "blog_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "dev"
  cidr = "10.0.0.0/16"

  azs = ["us-east-2a", "us-east-2b", "us-east-2c"]
  public_subnets = ["10.0.101.0/24, "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "autoscaling" {
  source = "terraform-aws-modules/autoscaling/aws"
  version = "6.5.2"
}