output "secret_name" {
  value = "${length(kubernetes_service_account.cats-and-dogs.*.default_secret_name) == 0 ? "" : element(kubernetes_service_account.cats-and-dogs.*.default_secret_name, 0)}"
}
