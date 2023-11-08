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