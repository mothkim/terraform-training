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

data "aws_secretsmanager_secret" "develop_be_app" {
  arn = "arn:aws:secretsmanager:ap-southeast-1:911990389614:secret:develop/be/app-HxQB8j"
}

output "develop_be_app" {
  value = data.aws_secretsmanager_secret.develop_be_app.arn
}

data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = data.aws_secretsmanager_secret.develop_be_app.id
}

output "secret_string" {
  value = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.secret_version.secret_string))
}