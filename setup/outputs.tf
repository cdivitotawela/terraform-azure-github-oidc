output "azure_subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

output "azure_tenant_id" {
  value = data.azurerm_subscription.current.tenant_id
}

output "azure_client_id" {
  value = azuread_application.app.client_id
}
