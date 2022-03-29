variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}


variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  #default     = ""
  description = "gke password"
}

variable "k8s_namespace" {
  #default     = ""
  description = "gke namespace"
}

variable "k8s_sa" {
  #default     = ""
  description = "gke sa"
}

variable "key_ring" {
  description = "Cloud KMS key ring name to create"
  default     = "test_keyring"
}

variable "crypto_key" {
  default     = "test_crypto"
  description = "Crypto key name to create under the key ring"
}