terraform {
  backend "azurerm" {}
  required_version = ">= 0.13.3"
  required_providers {
    azurerm = {
      version = ">=2.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}