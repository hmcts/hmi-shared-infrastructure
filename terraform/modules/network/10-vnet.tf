resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project}-vnet-${var.environment}"
  location            = var.location
  address_space       = var.address_space
  resource_group_name = var.resource_group
  tags                = var.tags
}

locals {
  dns_zone_name                = var.environment == "prod" ? "platform.hmcts.net" : "staging.platform.hmcts.net"
  peering_prod_vnets           = var.environment != "prod" && var.environment != "stg" ? ["hmcts-hub-prod-int"] : []
  peering_nonprod_vnets        = var.environment == "stg" ? ["hmcts-hub-nonprodi"] : []
  peering_prod_subscription    = "0978315c-75fe-4ada-9d11-1eb5e0e0b214"
  peering_nonprod_subscription = "fb084706-583f-4c9a-bdab-949aac66ba5c"
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_to_dns" {
  provider              = azurerm.private-dns-zone-subscription
  name                  = "${var.project}-vnet-${var.environment}"
  resource_group_name   = "core-infra-intsvc-rg"
  private_dns_zone_name = local.dns_zone_name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = var.tags
}

resource "azurerm_virtual_network_peering" "vnet_to_uks_prod_hub" {
  provider                  = azurerm.networking_client
  for_each                  = toset(local.peering_prod_vnets)
  name                      = each.value
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = "/subscriptions/${local.peering_prod_subscription}/resourceGroups/${each.value}/providers/Microsoft.Network/virtualNetworks/${each.value}"
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "vnet_to_uks_nonprod_hub" {
  provider                  = azurerm.networking_client
  for_each                  = toset(local.peering_nonprod_vnets)
  name                      = each.value
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = "/subscriptions/${local.peering_nonprod_subscription}/resourceGroups/${each.value}/providers/Microsoft.Network/virtualNetworks/${each.value}"
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "uks_prod_hub_to_vnet" {
  provider                  = azurerm.networking_requester
  for_each                  = toset(local.peering_prod_vnets)
  name                      = azurerm_virtual_network.vnet.name
  resource_group_name       = each.value
  virtual_network_name      = each.value
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "uks_nonprod_hub_to_vnet" {
  provider                  = azurerm.networking_requester_nonprod
  for_each                  = toset(local.peering_nonprod_vnets)
  name                      = azurerm_virtual_network.vnet.name
  resource_group_name       = each.value
  virtual_network_name      = each.value
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  allow_forwarded_traffic   = true
}
