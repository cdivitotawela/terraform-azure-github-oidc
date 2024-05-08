data "azurerm_subscription" "current" {}

resource "random_string" "random" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "tfstate${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_container" "container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "local_file" "backend_file" {
  filename        = "${path.module}/../backend.tfvars"
  file_permission = "0644"
  content         = <<-EOT
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  storage_account_name = "${azurerm_storage_account.storage_account.name}"
  container_name       = "${azurerm_storage_container.container.name}"
  subscription_id      = "${data.azurerm_subscription.current.subscription_id}"
  tenant_id            = "${data.azurerm_subscription.current.tenant_id}"
  EOT
}