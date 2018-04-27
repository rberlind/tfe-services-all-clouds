output "cats_and_dogs_address" {
  value = "${var.service_account_from_yaml == 0 ?
  kubernetes_service.cats-and-dogs-frontend.load_balancer_ingress.0.ip : ""}"
}
