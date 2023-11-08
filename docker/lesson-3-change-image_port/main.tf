terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

# for MacOS #
provider "docker" {
  host = "unix:///Users/deen/.docker/run/docker.sock"
}

# for Linux #
# provider "docker" {
#   host = "unix:///var/run/docker.sock"
# }

# for Windows #
# provider "docker" {
#   host = "npipe:////.//pipe//docker_engine"
# }

resource "docker_container" "my_container" {
  name  = var.container_name
  image = docker_image.my_image.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }
}

# Find the latest Ubuntu precise image.
resource "docker_image" "my_image" {
  name = "bitnami/nginx:latest"
}

variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "my-container"
}

variable "internal_port" {
  description = "Internal Port for the Docker container"
  type        = number
  default     = "80"
}

variable "external_port" {
  description = "External Port for the Docker container"
  type        = number
  default     = "8080"
}