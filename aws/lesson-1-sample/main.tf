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

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

# internet_gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_training.id
}

# router table default
resource "aws_route" "default_route" {
  route_table_id         = aws_vpc.vpc_training.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


# subnet
resource "aws_subnet" "subnet_training" {
  vpc_id     = aws_vpc.vpc_training.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "training-terraform"
  }
}

# security_group 
resource "aws_security_group" "internet_facing" {
  name        = "internet_facing"
  description = "internet_facing"
  vpc_id      = aws_vpc.vpc_training.id

#   ingress {
#     description      = "HTTP:80"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "internet_facing"
  }
}

# security_group_rule
resource "aws_security_group_rule" "allow_80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.internet_facing.id
}