resource "azurerm_route_table" "apim_rt" {
  name                          = "${var.project}-rt-${var.environment}"
  location                      = var.location
  resource_group_name           = var.resource_group
  disable_bgp_route_propagation = false
  tags                          = var.tags

  dynamic "route" {
    for_each = var.route_table
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }
}

resource "azurerm_subnet_route_table_association" "sub_rt" {
  subnet_id      = azurerm_subnet.apim_subnet.id
  route_table_id = azurerm_route_table.apim_rt.id
}


resource "azurerm_route" "stg_aks_route_rule" {
  count    = var.environment == "dev" || var.environment == "test" ? 1 : 0
  provider = azurerm.networking_staging

  name                   = "hmi-ss-${var.environment}-vnet"
  resource_group_name    = "ss-stg-network-rg"
  route_table_name       = "aks-stg-appgw-route-table"
  address_prefix         = var.address_space
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.11.8.36"
}