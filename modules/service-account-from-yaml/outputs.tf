output "secret_name" {
  value = "${length(data.null_data_source.retrieve_secret_name_from_file.*.outputs["secret_name"]) == 0 ? "" : element(data.null_data_source.retrieve_secret_name_from_file.*.outputs["secret_name"], 0) }"
}
