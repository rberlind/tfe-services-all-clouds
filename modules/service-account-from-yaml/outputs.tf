output "secret_name" {
  value = "${data.null_data_source.retrieve_secret_name_from_file.outputs["secret_name"]}"
}

output "cats_and_dogs_address" {
  value = "${var.count == 0 ?
  "" : coalesce("http://cats-and-dogs-frontend.${data.terraform_remote_state.k8s_cluster.master_public_ip}.xip.io", "")}"
}
