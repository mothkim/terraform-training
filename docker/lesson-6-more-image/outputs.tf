output "container_id-1" {
  description = "ID of the Docker container"
  value       = docker_container.my_container-1.id
}

output "image_id-1" {
  description = "ID of the Docker image"
  value       = docker_image.my_image-1.id
}

output "container_id-2" {
  description = "ID of the Docker container"
  value       = docker_container.my_container-2.id
}

output "image_id-2" {
  description = "ID of the Docker image"
  value       = docker_image.my_image-2.id
}