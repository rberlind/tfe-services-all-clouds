output "cats_and_dogs_address_azure" {
  value = "${module.cats_and_dogs_azure.cats_and_dogs_address}"
}

output "cats_and_dogs_address_gcp" {
  value = "${module.cats_and_dogs_gcp.cats_and_dogs_address}"
}

output "cats_and_dogs_address_aws" {
  value = "${module.cats_and_dogs_aws.cats_and_dogs_address}"
}
