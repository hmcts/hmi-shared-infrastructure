terraform {
  backend "azurerm" {}
  required_version = ">= 1.0.4"
  required_providers {
    azurerm = {
      version = ">=2.99.0"
    }
  }
}

provider "azurerm" {
  features {}
}
provider "azurerm" {
  features {}
  alias           = "pip_stg"
  subscription_id = "74dacd4f-a248-45bb-a2f0-af700dc4cf68"
}