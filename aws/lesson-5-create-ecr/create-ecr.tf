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

# Create Secret Manager

# Firstly create a random generated password to use in secrets.
resource "random_password" "ecr_password" {
  length  = 16
  special = false
}

# Creating a AWS secret for ECR
resource "aws_secretsmanager_secret" "ecr_password_secret" {
  name = "develop/ecr/password"
}

# Creating a AWS secret versions for ECR
resource "aws_secretsmanager_secret_version" "ecr_password_secret_version" {
  secret_id     = aws_secretsmanager_secret.ecr_password_secret.id
  # secret_string = random_password.ecr_password.result
  secret_string = <<EOF
   {
    "username": "admin",
    "password": "${random_password.ecr_password.result}"
   }
  EOF
}

# Importing the AWS secrets created previously using arn.
data "aws_secretsmanager_secret" "ecr_password_secret" {
  arn = aws_secretsmanager_secret.ecr_password_secret.arn
}
 
# Importing the AWS secret version created previously using arn.
data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.ecr_password_secret.arn
}
 
# After importing the secrets storing into Locals
locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
}
#-- End Secret Manager --#


# Create ECR Repository
resource "aws_ecr_repository" "my_ecr_repository" {
  name                 = "my-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Create ECR Repository Policy
resource "aws_ecr_lifecycle_policy" "my_ecr_repository_policy" {
  repository = aws_ecr_repository.my_ecr_repository.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

output "ecr_login_credentials" {
  value    = aws_ecr_repository.my_ecr_repository
}