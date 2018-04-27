output "secret_name" {
  value = "${length(data.null_data_source.retrieve_secret_name_from_file.*.outputs["secret_name"]) == 0 ? join("", data.null_data_source.retrieve_secret_name_from_file.*.outputs["secret_name"]) : join("", data.null_data_source.retrieve_secret_name_from_file.*.outputs["secret_name"])}"
}
