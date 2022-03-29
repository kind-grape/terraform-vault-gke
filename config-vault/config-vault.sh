# first need to init the vault using 1 recovery key 
vault operator init -recovery-shares=1 -recovery-threshold=1 

# login using the root token 
vault login {token}

# enable gcp secret engine 
vault secrets enable gcp 

# since vault is within the GKE, will not be configuring the path

# create the roleset binding
cd /home/vault
vi binding.hcl
resource "//cloudresourcemanager.googleapis.com/projects/richp-gke" {
  roles = [
    "roles/compute.instanceAdmin.v1",
    "roles/iam.serviceAccountUser",  
    "roles/viewer",
    "roles/container.viewer",
  ]
}

# create the roleset
vault write gcp/roleset/richp-gke-token project="richp-gke" secret_type="access_token"  token_scopes="https://www.googleapis.com/auth/cloud-platform" bindings=@binding.hcl

# read the vault gcp roleset token endpoint to get the oauth token 
vault read gcp/roleset/richp-gke-token/token