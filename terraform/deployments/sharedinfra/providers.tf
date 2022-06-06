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
