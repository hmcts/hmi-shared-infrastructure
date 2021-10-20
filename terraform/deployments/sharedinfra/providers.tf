terraform {
  backend "azurerm" {}
  required_version = ">= 0.14.0"
  required_providers {
    azurerm = {
      version = ">=2.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}