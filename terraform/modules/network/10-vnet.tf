resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project}-vnet-${var.environment}"
  location            = var.location
  address_space       = var.address_space
  resource_group_name = var.resource_group
  tags                = var.tags
}

locals {
  dns_zone_name        = var.environment == "prod" ? "platform.hmcts.net" : "staging.platform.hmcts.net"
  peering_vnets        = var.environment != "prod" && var.environment != "stg" ? ["hmcts-hub-prod-int", "ukw-hub-prod-int"] : []
  peering_subscription = "0978315c-75fe-4ada-9d11-1eb5e0e0b214"
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_to_dns" {
  provider              = azurerm.private-dns-zone-subscription
  name                  = "${var.project}-vnet-${var.environment}"
  resource_group_name   = "core-infra-intsvc-rg"
  private_dns_zone_name = local.dns_zone_name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_virtual_network_peering" "vnet_to_uks_prod_hub" {
  provider                  = azurerm.networking_client
  for_each                  = toset(local.peering_vnets)
  name                      = each.value
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = "/subscriptions/${local.peering_subscription}/resourceGroups/${each.value}/providers/Microsoft.Network/virtualNetworks/${each.value}"
  allow_forwarded_traffic   = true
}
