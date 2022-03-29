provider "google" {
  # need to login to gcp using application default 
  #   gcloud auth application-default login
  project = var.project_id
  region  = var.region
}

# terraform {
#   required_providers {
#     google = {
#       source  = "hashicorp/google"
#       version = "3.52.0"
#     }
#   }

#   required_version = ">= 0.14"
# }