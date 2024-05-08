terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

  backend "azurerm" {
    key      = "main"
    use_oidc = true
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}
