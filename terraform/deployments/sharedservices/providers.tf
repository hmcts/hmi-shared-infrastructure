terraform {
  required_version = ">= 0.15.4"
  required_providers {
    azurerm = {
      version = ">=2.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}
