terraform {
  backend "azurerm" {}
  required_version = ">= 1.0.6"
  required_providers {
    azurerm = {
      version = ">=2.97.0"
    }
  }
}

provider "azurerm" {
  features {}
}