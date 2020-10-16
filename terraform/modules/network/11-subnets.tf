resource "azurerm_subnet" "apim_subnet" {
  name                 = "apim-subnet-${var.environment}"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [element(var.subnet_address_prefixes, 0)]
}

resource "azurerm_subnet" "mgmt_subnet" {
  name                                           = "mgmt-subnet-${var.environment}"
  resource_group_name                            = var.resource_group
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [element(var.subnet_address_prefixes, 1)]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}
