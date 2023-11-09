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

data "aws_availability_zones" "available" {}

# vpc
resource "aws_vpc" "vpc_training" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "training-terraform"
  }
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
resource "aws_subnet" "subnet_training_1" {
  vpc_id     = aws_vpc.vpc_training.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "training-terraform"
  }
}

resource "aws_subnet" "subnet_training_2" {
  vpc_id     = aws_vpc.vpc_training.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"

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

# ECS Cluster
resource "aws_ecs_cluster" "ecs" {
  name = "my-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cap" {
  cluster_name = aws_ecs_cluster.ecs.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# Task Definition
data "aws_iam_role" "ecs_task_execution_role" { name = "ecsTaskExecutionRole" }
data "aws_iam_role" "ecs_task_role" { name = "ecsTaskExecutionRole" }

resource "aws_ecs_task_definition" "my_definition" {
  family                   = "my_definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_role.arn
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "my-nginx",
    "image": "nginx:latest",
    "cpu": 1024,
    "memory": 1024,
    "essential": true,
    "portMappings": [
        {
            "name": "nginx-80-tcp",
            "containerPort": 80,
            "hostPort": 80,
            "protocol": "tcp",
            "appProtocol": "http"
        }
    ]
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}


# target group
resource "aws_lb_target_group" "aws_lb_target_group" {
  name       = "aws-lb-target-group"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.vpc_training.id
  slow_start = 0
  target_type = "ip"
  load_balancing_algorithm_type = "round_robin"

  health_check {
    enabled             = true
    port                = 80
    interval            = 30
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# load balancer
resource "aws_lb" "my_app" {
  name               = "my-app"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internet_facing.id]

  subnets = [
    aws_subnet.subnet_training_1.id,
    aws_subnet.subnet_training_2.id,
  ]
}

# load balancer listener
resource "aws_lb_listener" "http_80" {
  load_balancer_arn = aws_lb.my_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_lb_target_group.arn
  }
}

# ecs service running
resource "aws_ecs_service" "aws_ecs_service" {
  
  capacity_provider_strategy {
    base              = "1"
    capacity_provider = "FARGATE"
    weight            = "100"
  }

  cluster = "my-cluster"

  deployment_circuit_breaker {
    enable   = "true"
    rollback = "true"
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "100"
  desired_count                      = "1"
  enable_ecs_managed_tags            = "true"
  enable_execute_command             = "false"
  health_check_grace_period_seconds  = "0"

  load_balancer {
    container_name   = "my-nginx"
    container_port   = "80"
    target_group_arn = aws_lb_target_group.aws_lb_target_group.arn
  }

  name = "my-nginx"

  network_configuration {
    assign_public_ip = "true"
    security_groups  = [aws_security_group.internet_facing.id]
    subnets          = [aws_subnet.subnet_training_1.id, aws_subnet.subnet_training_2.id]
  }

  platform_version    = "LATEST"
  scheduling_strategy = "REPLICA"
  task_definition     = aws_ecs_task_definition.my_definition.arn
  depends_on = [aws_lb_listener.http_80]
}