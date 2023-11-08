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

resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = var.container_name

  ports {
    internal = "80"
    external = "8080"
  }
}

variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "my-container-name"
}