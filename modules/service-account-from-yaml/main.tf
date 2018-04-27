data "terraform_remote_state" "k8s_cluster" {
  backend = "atlas"
  config {
    name = "${var.tfe_organization}/${var.k8s_cluster_workspace}"
  }
}

resource "null_resource" "service_account" {
  count = "${var.count}"
  provisioner "file" {
    source = "cats-and-dogs.yaml"
    destination = "~/cats-and-dogs.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "oc new-project cats-and-dogs --description=\"cats and dogs project\" --display-name=\"cats-and-dogs\"",
      "kubectl create -f cats-and-dogs.yaml",
      "kubectl get serviceaccount cats-and-dogs -o yaml > cats-and-dogs-service.yaml",
      "grep \"cats-and-dogs-token\" cats-and-dogs-service.yaml | cut -d ':' -f 2 | sed 's/ //' > cats-and-dogs-secret-name"
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
}

resource "null_resource" "get_secret_name" {
  count = "${var.count}"
  provisioner "remote-exec" {
    inline = [
      "scp -o StrictHostKeyChecking=no -i ~/.ssh/private-key.pem ec2-user@${data.terraform_remote_state.k8s_cluster.master_public_dns}:~/cats-and-dogs-secret-name cats-and-dogs-secret-name"
    ]

    connection {
      host = "${data.terraform_remote_state.k8s_cluster.bastion_public_dns}"
      type = "ssh"
      agent = false
      user = "ec2-user"
      private_key = "${var.private_key_data}"
    }
  }

  provisioner "local-exec" {
    command = "echo \"${var.private_key_data}\" > private-key.pem"
  }

  provisioner "local-exec" {
    command = "chmod 400 private-key.pem"
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i private-key.pem  ec2-user@${data.terraform_remote_state.k8s_cluster.bastion_public_dns}:~/cats-and-dogs-secret-name cats-and-dogs-secret-name"
  }

  depends_on = ["null_resource.service_account"]
}

data "null_data_source" "retrieve_secret_name_from_file" {
  #count = "${var.count}"
  inputs = {
    secret_name = "${file("${path.module}/cats-and-dogs-secret-name")}"
  }
  depends_on = ["null_resource.get_secret_name"]
}
