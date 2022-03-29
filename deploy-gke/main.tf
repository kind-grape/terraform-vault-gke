# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

# GCP SA
resource "google_service_account" "vault-sa" {
  project      = var.project_id
  account_id   = "${var.project_id}-cluster-vault-sa"
  display_name = "Vault SA for GKE Cluster"
}

# IAM Role for GCP SA
resource "google_project_iam_member" "vault-sa-roles" {
  for_each = toset(var.gke_service_account_iam_roles)
  project  = var.project_id
  member = "serviceAccount:${google_service_account.vault-sa.email}"
  role = each.value
}


# crypto key for gcp auto unseal 
resource "google_kms_key_ring" "key_ring" {
  project  = var.project_id
  name     = var.key_ring
  location = var.region
}


resource "google_kms_crypto_key" "crypto_key" {
  name            = var.crypto_key
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = "100000s"
}

#Add SA to the keyring
resource "google_kms_key_ring_iam_binding" "vault_iam_kms_binding" {
  # key_ring_id = "${google_kms_key_ring.key_ring.id}"
  key_ring_id = "${var.project_id}/${var.region}/${var.key_ring}"
  role = "roles/owner"

  members = [
    "serviceAccount:${google_service_account.vault-sa.email}",
  ]
}


resource "google_container_cluster" "primary" {
  #depends_on = [google_service_account_iam_binding.bind-vault-sa]

  project  = var.project_id
  name     = "${var.project_id}-cluster"
  location = var.region

  initial_node_count = 1
  network            = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
  node_config {
    preemptible  = true
    machine_type = "e2-small"


    metadata = {
      disable-legacy-endpoints = true
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

# IAM Binding for Workload Identity
resource "google_service_account_iam_binding" "bind-vault-sa" {
  depends_on = [google_container_cluster.primary]

  service_account_id = google_service_account.vault-sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${var.k8s_namespace}/${var.k8s_sa}]"
  ]
}