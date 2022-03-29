terraform {
  backend "azurerm" {}
  required_version = ">= 1.0.4"
  required_providers {
    azurerm = {
      version = ">=2.99.0"
    }
    random = {
      version = ">= 2.2.0"
    }
    azuread = {
      version = ">=1.6.0"
    }
  }
}

provider "azurerm" {
  features {}
}
provider "random" {}
provider "azuread" {}