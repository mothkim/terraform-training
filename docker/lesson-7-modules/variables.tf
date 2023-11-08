## -- Image nginx:latest -- ##
variable "container_image_nginx" {
  description = "Name for the Docker container"
  type        = string
  default     = "nginx:latest"
}

variable "container_name_nginx" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "nginx"
}

variable "internal_port_nginx" {
  description = "Internal Port for the Docker container"
  type        = number
  default     = "80"
}

variable "external_port_nginx" {
  description = "External Port for the Docker container"
  type        = number
  default     = "8081"
}

## -- Image ubuntu/nginx:latest -- ##
variable "container_image_ubuntu_nginx" {
  description = "Name for the Docker container"
  type        = string
  default     = "ubuntu/nginx:latest"
}

variable "container_name_ubuntu_nginx" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "ubuntu-nginx"
}

variable "internal_port_ubuntu_nginx" {
  description = "Internal Port for the Docker container"
  type        = number
  default     = "80"
}

variable "external_port_ubuntu_nginx" {
  description = "External Port for the Docker container"
  type        = number
  default     = "8082"
}