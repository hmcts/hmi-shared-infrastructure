data "azurerm_resource_group" "aks" {
  name = "ss-${var.environment}-network-rg"
}

data "azurerm_virtual_network" "aks" {
  name                = "ss-${var.environment}-vnet"
  resource_group_name = data.azurerm_resource_group.aks.name
}

data "azurerm_resource_group" "hmi" {
  name = "hmi-sharedinfra-${var.environment}-rg"
}

data "azurerm_virtual_network" "hmi" {
  name                = "hmi-sharedinfra-vnet-${var.environment}"
  resource_group_name = data.azurerm_resource_group.hmi.name
}

# Generic locals
locals {
  common_tags = module.ctags.common_tags
}

module "ctags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.environment
  product     = var.product
  builtFrom   = var.builtFrom
}