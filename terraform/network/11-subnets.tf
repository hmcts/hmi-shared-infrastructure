resource "azurerm_subnet" "apim_subnet" {
  name                      = "apim-subnet-${var.environment}"
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.vnet.name
  address_prefixes          = [element(var.subnet_address_prefixes, 0)]

}

resource "azurerm_subnet" "mgmt_subnet" {
  name                      = "pact-subnet-${var.environment}"
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.vnet.name
  address_prefixes          = [element(var.subnet_address_prefixes, 1)]
}
