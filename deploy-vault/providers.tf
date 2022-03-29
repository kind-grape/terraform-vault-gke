provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_container_cluster" "my_cluster" {
  name     = "${var.project_id}-cluster"
  location = var.region
}

provider "kubernetes" {
  # need to run the proxy server on the GKE as the cluster IP might not be reachable 
  # 1. login to the GKE using gcloud 
  #      gcloud container clusters get-credentials {clustername} -region {region}
  # 2. run the proxy service 
  #      kubectl proxy
  host     = "http://127.0.0.1:8001"
  username = var.gke_username
  password = var.gke_password
  client_certificate     = base64decode(data.google_container_cluster.my_cluster.master_auth.0.client_certificate)
  client_key             = base64decode(data.google_container_cluster.my_cluster.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth.0.cluster_ca_certificate)
}

provider "helm" {
  # need to run the proxy server on the GKE as the cluster IP might not be reachable 
  # 1. login to the GKE using gcloud 
  #      gcloud container clusters get-credentials {clustername} -region {region}
  # 2. run the proxy service 
  #      kubectl proxy
  kubernetes {
    host     = "http://127.0.0.1:8001"
    username = var.gke_username
    password = var.gke_password
    client_certificate     = base64decode(data.google_container_cluster.my_cluster.master_auth.0.client_certificate)
    client_key             = base64decode(data.google_container_cluster.my_cluster.master_auth.0.client_key)
    cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth.0.cluster_ca_certificate)
  }
}