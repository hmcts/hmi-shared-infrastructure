resource "azurerm_route_table" "apim_rt" {
  name                          = "${var.product}-rt-${var.environment}"
  location                      = var.location
  resource_group_name           = var.resource_group
  disable_bgp_route_propagation = false
  tags                          = var.tags

  route {
    name                   = var.route_name
    address_prefix         = var.route_address_prefix
    next_hop_type          = var.route_next_hop_type
    next_hop_in_ip_address = var.next_hop_in_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "sub_rt" {
  subnet_id      = azurerm_subnet.apim_subnet.id
  route_table_id = azurerm_route_table.apim_rt.id
}