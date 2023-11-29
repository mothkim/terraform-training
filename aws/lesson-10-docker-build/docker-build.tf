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
  # File docker.sock on local run docker #
  host = "unix:///Users/deen/.docker/run/docker.sock"

  registry_auth {
    # Your Private Registry for Login #
    address  = "registry-1.docker.io"
  }
}

resource "docker_image" "new_image" {
  # Container Image Name #
  name = "registry-1.docker.io/mothkim/my-new-image-nginx:latest"
  build {
    # Find your File 'Dockerfile' #
    context = "."
  }
}

resource "docker_registry_image" "new_image" {
  # Container Image Name when push to Private Registry#
  name = docker_image.new_image.name
}