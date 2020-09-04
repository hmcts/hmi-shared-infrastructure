resource "azurerm_subnet" "apim_subnet" {
  name                      = "apim-subnet-${var.environment}"
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.vnet.name
  address_prefixes          = element(var.subnet_address_prefixes, 0)

  dynamic "delegation" {
    for_each = var.subnet_delegation == null ? [] : ["delegation"]
    content {
      name = var.subnet_delegation.name
      service_delegation {
        name      = var.subnet_delegation.service_delegation.name
        actions   = var.subnet_delegation.service_delegation.actions
      }
    }
  }
  enforce_private_link_endpoint_network_policies = true
  service_endpoints                              = var.service_endpoints
}

resource "azurerm_subnet" "perf_test_subnet" {
  name                      = "gw-subnet-${var.environment}"
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.vnet.name
  address_prefixes          = element(var.subnet_address_prefixes, 1)
}