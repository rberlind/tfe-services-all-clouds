variable "private_key_data" {
  description = "contents of the private key"
}

variable "count" {
  description = "count to determine whether to create service account"
}

variable "master_public_dns" {
  description = "DNS of master server"
}

variable "bastion_public_dns" {
  description = "DNS of bastion server"
}
