output "secret_name" {
  value = "${element(kubernetes_service_account.*.cats-and-dogs.default_secret_name, 0)}"
}
