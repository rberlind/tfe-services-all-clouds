variable "tfe_organization" {
  description = "TFE organization"
  default = "RogerBerlind"
}

variable "k8s_cluster_workspace_azure" {
  description = "workspace to use for the aks k8s cluster in Azure"
}

variable "k8s_cluster_workspace_gcp" {
  description = "workspace to use for the gke k8s cluster in Google"
}

variable "k8s_cluster_workspace_aws" {
  description = "workspace to use for the OpenShift k8s cluster in AWS"
}
