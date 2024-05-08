data "azuread_client_config" "current" {}

data "azurerm_subscription" "current" {}

# Current user will be the owner
resource "azuread_application" "app" {
  display_name = var.azure_app_name
  owners       = [data.azuread_client_config.current.object_id]
}

# Current user will be the owner
resource "azuread_service_principal" "sp" {
  client_id                    = azuread_application.app.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.sp.id
}

resource "azuread_application_federated_identity_credential" "credentials_branch" {
  application_id = azuread_application.app.id
  display_name   = "${var.azure_app_name}-${var.github_repository_branch}-branch"
  description    = "GitHub OIDC claim to allow changes from repository ${var.github_repository} on ${var.github_repository_branch} branch"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_repository}:ref:refs/heads/${var.github_repository_branch}"
}

resource "azuread_application_federated_identity_credential" "credentials_pull_request" {
  application_id = azuread_application.app.id
  display_name   = "${var.azure_app_name}-pull-request"
  description    = "GitHub OIDC claim to allow from repository ${var.github_repository} pull request"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_repository}:pull_request"
}

resource "azuread_application_federated_identity_credential" "credentials_environment" {
  application_id = azuread_application.app.id
  display_name   = "${var.azure_app_name}-env-${var.github_repository_environment}"
  description    = "GitHub OIDC claim to allow from repository ${var.github_repository} environment ${var.github_repository_environment}"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_repository}:environment:${var.github_repository_environment}"
}

# resource "local_file" "workflow" {
#   filename        = "${path.module}/../.github/workflows/azure.yml"
#   file_permission = "0644"
#   content = templatefile("github-workflow-template.tftpl", {
#     subscription_id = "${data.azurerm_subscription.current.subscription_id}"
#     client_id       = "${azuread_application.app.client_id}"
#     tenant_id       = "${data.azurerm_subscription.current.tenant_id}"
#   })
# }