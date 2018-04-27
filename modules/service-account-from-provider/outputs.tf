output "secret_name" {
  value = "${compact(kubernetes_service_account.cats-and-dogs.*.default_secret_name)}"
}
