resource "docker_container" "my_container" {
  name  = var.container_name
  image = docker_image.my_image.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }
}

resource "docker_image" "my_image" {
  name = "bitnami/nginx:latest"
}