output "secret_name" {
  value = "${kubernetes_service_account.cats-and-dogs.default_secret_name}"
}
