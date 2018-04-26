data "terraform_remote_state" "k8s_cluster" {
  backend = "atlas"
  config {
    name = "${var.tfe_organization}/${var.k8s_cluster_workspace}"
  }
}

provider "kubernetes" {
  host = "${data.terraform_remote_state.k8s_cluster.k8s_endpoint}"
  client_certificate = "${base64decode(data.terraform_remote_state.k8s_cluster.k8s_master_auth_client_certificate)}"
  client_key = "${base64decode(data.terraform_remote_state.k8s_cluster.k8s_master_auth_client_key)}"
  cluster_ca_certificate = "${base64decode(data.terraform_remote_state.k8s_cluster.k8s_master_auth_cluster_ca_certificate)}"
}

module "service-account-from-provider" {
  source = "../service-account-from-provider"
  count = "${1 - var.service_account_from_yaml}"
}

module "service-account-from-yaml" {
  source = "../service-account-from-yaml"
  private_key_data = "${var.private_key_data}"
  count = "${var.service_account_from_yaml}"
  master_public_dns = "${data.terraform_remote_state.k8s_cluster.master_public_dns}"
  bastion_public_dns = "${data.terraform_remote_state.k8s_cluster.bastion_public_dns}"
}

locals {
  secret_name = "${var.service_account_from_yaml == 0 ? module.service-account-from-provider.secret_name : module.service-account-from-yaml.secret_name}"
}

resource "kubernetes_pod" "cats-and-dogs-backend" {
  metadata {
    name = "cats-and-dogs-backend"
    labels {
      App = "cats-and-dogs-backend"
    }
  }
  spec {
    service_account_name = "cats-and-dogs"
    container {
      image = "rberlind/cats-and-dogs-backend:k8s-auth"
      image_pull_policy = "Always"
      name  = "cats-and-dogs-backend"
      command = ["/app/start_redis.sh"]
      env = {
        name = "VAULT_ADDR"
        value = "${data.terraform_remote_state.k8s_cluster.vault_addr}"
      }
      env = {
        name = "VAULT_K8S_BACKEND"
        value = "${data.terraform_remote_state.k8s_cluster.vault_k8s_auth_backend}"
      }
      env = {
        name = "VAULT_USER"
        value = "${data.terraform_remote_state.k8s_cluster.vault_user}"
      }
      env = {
        name = "K8S_TOKEN"
        value_from {
          secret_key_ref {
            name = "${local.secret_name}"
            key = "token"
          }
        }
      }
      port {
        container_port = 6379
      }
    }
  }
}

resource "kubernetes_service" "cats-and-dogs-backend" {
  metadata {
    name = "cats-and-dogs-backend"
  }
  spec {
    selector {
      App = "${kubernetes_pod.cats-and-dogs-backend.metadata.0.labels.App}"
    }
    port {
      port = 6379
      target_port = 6379
    }
  }
}

resource "kubernetes_pod" "cats-and-dogs-frontend" {
  metadata {
    name = "cats-and-dogs-frontend"
    labels {
      App = "cats-and-dogs-frontend"
    }
  }
  spec {
    service_account_name = "cats-and-dogs"
    container {
      image = "rberlind/cats-and-dogs-frontend:k8s-auth"
      image_pull_policy = "Always"
      name  = "cats-and-dogs-frontend"
      env = {
        name = "REDIS"
        value = "cats-and-dogs-backend"
      }
      env = {
        name = "VAULT_ADDR"
        value = "${data.terraform_remote_state.k8s_cluster.vault_addr}"
      }
      env = {
        name = "VAULT_K8S_BACKEND"
        value = "${data.terraform_remote_state.k8s_cluster.vault_k8s_auth_backend}"
      }
      env = {
        name = "VAULT_USER"
        value = "${data.terraform_remote_state.k8s_cluster.vault_user}"
      }
      env = {
        name = "K8S_TOKEN"
        value_from {
          secret_key_ref {
            name = "${local.secret_name}"
            key = "token"
          }
        }
      }
      port {
        container_port = 80
      }
    }
  }

  depends_on = ["kubernetes_service.cats-and-dogs-backend"]
}

resource "kubernetes_service" "cats-and-dogs-frontend" {
  metadata {
    name = "cats-and-dogs-frontend"
  }
  spec {
    selector {
      App = "${kubernetes_pod.cats-and-dogs-frontend.metadata.0.labels.App}"
    }
    port {
      port = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}

resource "null_resource" "expose_route" {
  count = "${var.service_account_from_yaml}"
  provisioner "remote-exec" {
    inline = [
      "oc expose service cats-and-dogs-frontend --hostname=cats-and-dogs-frontend.${data.terraform_remote_state.k8s_cluster.master_public_ip}.xip.io"
    ]
  }

  connection {
    host = "${data.terraform_remote_state.k8s_cluster.master_public_dns}"
    type = "ssh"
    agent = false
    user = "ec2-user"
    private_key = "${var.private_key_data}"
    bastion_host = "${data.terraform_remote_state.k8s_cluster.bastion_public_dns}"
  }

  depends_on = ["kubernetes_service.cats-and-dogs-frontend"]

}
