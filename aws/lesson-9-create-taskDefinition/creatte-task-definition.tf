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

resource "aws_ecs_task_definition" "task_defind_pri_registry" {
  family                   = "test"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = "arn:aws:iam::911990389614:role/${data.aws_iam_role.example.name}"
  task_role_arn            = "arn:aws:iam::911990389614:role/${data.aws_iam_role.example.name}"
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "nginx",
    "image": "mothkim/nginx:latest",
    "repositoryCredentials": {
      "credentialsParameter": "arn:aws:secretsmanager:ap-southeast-1:911990389614:secret:my-docker-hub-4RbN7Z"
    },
    "cpu": 1024,
    "memory": 2048,
    "essential": true
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

data "aws_secretsmanager_secret" "my-docker-hub" {
  arn = "arn:aws:secretsmanager:ap-southeast-1:911990389614:secret:my-docker-hub-4RbN7Z"
}

data "aws_secretsmanager_secret_version" "my-docker-hub" {
  secret_id = data.aws_secretsmanager_secret.my-docker-hub.id
}

output "am_roles" {
  value = data.aws_iam_role.example.name
}

data "aws_iam_role" "example" {
  name = "ecsTaskExecutionRole"
}