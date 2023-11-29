terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-1"
}

variable "vpc_id" {
  type = string
  default = "vpc-0894036724877c60f"
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_subnet" "my_subnet_variable" {
  vpc_id     = data.aws_vpc.selected.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "my_subnet_variable"
  }
}