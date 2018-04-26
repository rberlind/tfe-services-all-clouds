variable "tfe_organization" {
  description = "TFE organization"
}

variable "k8s_cluster_workspace" {
  description = "workspace with cluster state"
}

variable "private_key_data" {
  description = "contents of the private key"
}

variable "service_account_from_yaml" {
  # Set to 1 for OpenShift, else 0
  description = "whether to create service account from yaml"
}
