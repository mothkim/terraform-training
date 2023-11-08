# Run Container #
resource "docker_container" "container_run" {
  name  = var.container_name
  image = docker_image.container_image.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }
}

# Image Container #
resource "docker_image" "container_image" {
  name = var.container_image
}

output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.container_run.id
}

output "image_id" {
  description = "ID of the Docker image"
  value       = docker_image.container_image.id
}