terraform {
  required_version = ">= 0.12.0"
  backend "azurerm" {}
}

provider "azurerm" {
  version = ">=2.0.0"
  features {}
}

provider "azurerm" {
  subscription_id = var.log_analytics_subscription_id
  alias           = "log-analytics-subscription"
  version         = ">=2.0.0"
  features {}
}
