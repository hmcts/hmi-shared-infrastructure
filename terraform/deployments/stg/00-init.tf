terraform {
  required_version = ">= 0.13.3"
  backend "azurerm" {}
}

provider "azurerm" {
  version = ">=2.0.0"
  features {}
}
