resource "kubernetes_namespace" "vault" {
  metadata {
    name = var.k8s_namespace
  }
}

data "google_service_account" "vault-sa" {
  account_id = "${var.project_id}-cluster-vault-sa"
}

resource "kubernetes_service_account" "vault-k8s-sa" {
  metadata {
    name        = var.k8s_sa
    namespace   = var.k8s_namespace
    annotations = { "iam.gke.io/gcp-service-account" = data.google_service_account.vault-sa.email }
  }
}

resource "helm_release" "vault" {
  name       = "gke-vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  namespace  = kubernetes_namespace.vault.metadata.0.name

  values = [
    templatefile("templates/values.tmpl", {
      gke_service_account = kubernetes_service_account.vault-k8s-sa.metadata.0.name
      #gke_service_account = "${var.project_id}-cluster-vault-sa"
      project_id = var.project_id
      region = var.region
      key_ring = var.key_ring
      crypto_key = var.crypto_key

    })
  ]
}