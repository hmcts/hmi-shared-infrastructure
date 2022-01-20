terraform {
  required_version = ">= 1.0.4"
  required_providers {
    azurerm = {
      version = ">=2.0.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.log_analytics_subscription_id
  alias           = "log-analytics-subscription"
  features {}
}
provider "azurerm" {
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
  alias           = "private-dns-zone-subscription"
  features {}
}

data "azurerm_client_config" "current" {}
provider "azurerm" {
  features {}
  alias           = "networking_requester"
  subscription_id = "0978315c-75fe-4ada-9d11-1eb5e0e0b214"
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}
provider "azurerm" {
  features {}
  alias           = "networking_client"
  subscription_id = data.azurerm_client_config.current.subscription_id
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}