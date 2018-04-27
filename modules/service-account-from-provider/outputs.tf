output "secret_name" {
  value = "${ length(kubernetes_service_account.cats-and-dogs.*.default_secret_name) == 0 ? join("", kubernetes_service_account.cats-and-dogs.*.default_secret_name): join("", kubernetes_service_account.cats-and-dogs.*.default_secret_name)}"
}
