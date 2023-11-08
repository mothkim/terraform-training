# module "create_nginx" {
#   source = "./modules/docker-container"
#   container_image  = "nginx:latest"
#   container_name   = "nginx"   
#   internal_port    = "80"
#   external_port    = "8080"
# }

# module "create_ubuntu_nginx" {
#   source = "./modules/docker-container"
#   container_image  = "ubuntu/nginx:latest"
#   container_name   = "ubuntu-nginx"   
#   internal_port    = "80"
#   external_port    = "8081"
# }

module "create_nginx" {
  source = "./modules/docker-container"
  container_image  = var.container_image_nginx
  container_name   = var.container_name_nginx
  internal_port    = var.internal_port_nginx
  external_port    = var.external_port_nginx
}

module "create_ubuntu_nginx" {
  source = "./modules/docker-container"
  container_image  = var.container_image_ubuntu_nginx
  container_name   = var.container_name_ubuntu_nginx  
  internal_port    = var.internal_port_ubuntu_nginx
  external_port    = var.external_port_ubuntu_nginx
}