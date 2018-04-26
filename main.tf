terraform {
  required_version = ">= 0.11.7"
}

module "cats_and_dogs_azure" {
  source = "./cats-and-dogs"
  tfe_organization = "${var.tfe_organization}"
  k8s_cluster_workspace = "${var.k8s_cluster_workspace_azure}"
}

module "cats_and_dogs_gcp" {
  source = "./cats-and-dogs"
  tfe_organization = "${var.tfe_organization}"
  k8s_cluster_workspace = "${var.k8s_cluster_workspace_gcp}"
}

module "cats_and_dogs_aws" {
  source = "./cats-and-dogs"
  tfe_organization = "${var.tfe_organization}"
  k8s_cluster_workspace = "${var.k8s_cluster_workspace_aws}"
}
