output "resource_group" {
  value = azurerm_resource_group.resource_group.name
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "container_name" {
  value = azurerm_storage_container.container.name
}