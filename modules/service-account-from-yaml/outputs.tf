output "secret_name" {
  value = "${compact(data.null_data_source.retrieve_secret_name_from_file.*.outputs["secret_name"])}"
}
