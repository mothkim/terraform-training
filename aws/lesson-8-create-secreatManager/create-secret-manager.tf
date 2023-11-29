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

resource "aws_secretsmanager_secret" "my_secret_manager" {
  name = "my_secret_manager"
}

# Variable : Your Key / Value #
variable "my_secret_manager" {
  default = {
    username = "my-username"
    password = "my-password"
  }
  type = map(string)
}

resource "aws_secretsmanager_secret_version" "my_secret_manager_version" {
  secret_id     = aws_secretsmanager_secret.my_secret_manager.id
  secret_string = jsonencode(var.my_secret_manager)
}

output "my_secret_manager_arn" {
  value = aws_secretsmanager_secret.my_secret_manager.arn
}
output "my_secret_manager_all" {
  value = aws_secretsmanager_secret.my_secret_manager
}