terraform {
  required_version = ">= 0.11.7"
}

module "cats_and_dogs_azure" {
  source = "./modules/cats-and-dogs"
  tfe_organization = "${var.tfe_organization}"
  k8s_cluster_workspace = "${var.k8s_cluster_workspace_azure}"
  namespace = "${var.namespace_azure}"
  private_key_data = "${var.private_key_data}"
  service_account_from_yaml = "0"
}

module "cats_and_dogs_gcp" {
  source = "./modules/cats-and-dogs"
  tfe_organization = "${var.tfe_organization}"
  k8s_cluster_workspace = "${var.k8s_cluster_workspace_gcp}"
  namespace = "${var.namespace_gcp}"
  private_key_data = "${var.private_key_data}"
  service_account_from_yaml = "0"
}

module "cats_and_dogs_aws" {
  source = "./modules/cats-and-dogs"
  tfe_organization = "${var.tfe_organization}"
  k8s_cluster_workspace = "${var.k8s_cluster_workspace_aws}"
  namespace = "${var.namespace_aws}"
  private_key_data = "${var.private_key_data}"
  service_account_from_yaml = "1"
}
