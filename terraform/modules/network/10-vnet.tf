resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project}-vnet-${var.environment}"
  location            = var.location
  address_space       = var.address_space
  resource_group_name = var.resource_group
  tags                = var.tags
}

locals {
  dns_zone_name = var.environment == "prod" ? "platform.hmcts.net" : "staging.platform.hmcts.net"
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  provider              = azurerm.private-dns-zone-subscription
  name                  = "${var.project}-vnet-${var.environment}"
  resource_group_name   = "core-infra-intsvc-rg"
  private_dns_zone_name = local.dns_zone_name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}