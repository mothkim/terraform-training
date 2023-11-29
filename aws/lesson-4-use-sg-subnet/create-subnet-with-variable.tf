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

resource "aws_instance" "my_ec2" {
  ami = "ami-02453f5468b897e31"
  instance_type = "t2.micro"
  subnet_id = "subnet-05d5bb43d3b2ed027"

  vpc_security_group_ids = ["sg-00c4b40faa6dabc82"]
  # root_block_device {
  #   delete_on_termination = true
  #   iops = 150
  #   volume_size = 50
  #   volume_type = "gp2"
  # }
  tags = {
    Name ="SERVER01"
    Environment = "DEV"
  }
}