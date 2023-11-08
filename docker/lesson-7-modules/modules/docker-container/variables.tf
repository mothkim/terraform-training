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

variable "container_image" {
  description = "Name for the Docker container"
  type        = string
  default     = "nginx:latest"
}