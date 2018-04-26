resource "kubernetes_service_account" "cats-and-dogs" {
  count = "${var.count}"
  metadata {
    name = "cats-and-dogs"
  }
}
