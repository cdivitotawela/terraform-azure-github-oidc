# Terraform GitHub Azure OIDC Integration

This repository has example implementation of running Terraform from GitHub action to manage the Azure 
resources using the GitHub-Azure OIDC


## Azure Setup
Terraform code in [terraform/setup](./terraform/setup) is the bootstrap Azure configuration to enable the OIDC
integration with GitHub. This is run manually by a user who have access to Azure. Terraform state is managed in local
file.

Following commands run from the laptop
```sh
# Azure login and set subscription
az login
az account set --name <subscription name>
az account show

# Create Azure backend for Terraform
# This creates the backend.tfvar file which will be used in next stages
cd init
terraform init
terraform apply

# Terraform setup
cd terraform/setup
terraform init -backend-config=../backend.tfvars
terraform apply
```

Terraform output contains Azure subscription id, tenant id and client id. Configure following GitHub action secrets in the GitHub
repository as repository secrets.

| GitHub Action Secret    | Value                                           |
|-------------------------|-------------------------------------------------|
| `AZURE_CLIENT_ID`       | Azure app client id from the Terraform output   |
| `AZURE_TENANT_ID`       | Azure tenant id from the Terraform output       |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription id from the Terraform output |
| `AZURE_RESOURCE_GROUP`  | Azure resource group for Terraform backend      |
| `AZURE_STOREAGE_ACCOUNT`| Azure storage account for Terraform backend     |
| `AZURE_CONTAINER_NAME`  | Azure container name for Terraform backend      |

If the backend.tfvars file commit to the repository, make sure client_id is added
