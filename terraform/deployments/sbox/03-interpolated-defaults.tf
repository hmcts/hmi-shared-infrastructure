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