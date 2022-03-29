variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "gke_service_account_iam_roles" {
  default = [
    "roles/compute.viewer",
    "roles/cloudkms.cryptoKeyEncrypterDecrypter",
    "roles/cloudkms.viewer",
    ## roles permission needed to for gcp secret engine 
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/iam.serviceAccountTokenCreator",
    "roles/iam.securityAdmin",
    "roles/iam.securityReviewer",
  ]
  description = "IAM roles for the GCP SA"
}

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  #default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
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