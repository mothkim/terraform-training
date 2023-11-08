resource "docker_container" "my_container-1" {
  name  = var.container_name-1
  image = docker_image.my_image-1.image_id

  ports {
    internal = var.internal_port-1
    external = var.external_port-1
  }
}

resource "docker_image" "my_image-1" {
  name = "nginx:latest"
}

resource "docker_container" "my_container-2" {
  name  = var.container_name-2
  image = docker_image.my_image-2.image_id

  ports {
    internal = var.internal_port-2
    external = var.external_port-2
  }
}

resource "docker_image" "my_image-2" {
  name = "bitnami/nginx:latest"
}