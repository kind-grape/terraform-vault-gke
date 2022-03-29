# data "google_project" "read-project" {
# }

# output "project-number" {
#   value       = data.google_project.read-project.number
# }

data "google_service_account" "get-acct" {
  account_id = "richp-gke-cluster-vault-sa"
}



output "acct-id" {
  value       = data.google_service_account.get-acct.unique_id
}