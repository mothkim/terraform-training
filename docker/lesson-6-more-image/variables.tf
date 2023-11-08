variable "container_name-1" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "my-container-1"
}

variable "internal_port-1" {
  description = "Internal Port for the Docker container"
  type        = number
  default     = "80"
}

variable "external_port-1" {
  description = "External Port for the Docker container"
  type        = number
  default     = "8081"
}

variable "container_name-2" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "my-container-2"
}

variable "internal_port-2" {
  description = "Internal Port for the Docker container"
  type        = number
  default     = "80"
}

variable "external_port-2" {
  description = "External Port for the Docker container"
  type        = number
  default     = "8082"
}