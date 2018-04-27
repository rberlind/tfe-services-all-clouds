output "secret_name" {
  value = "${join("", kubernetes_service_account.cats-and-dogs.*.default_secret_name)}"
}
