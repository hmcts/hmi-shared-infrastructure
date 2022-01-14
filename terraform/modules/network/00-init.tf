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

