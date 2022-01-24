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


resource "azurerm_route" "target_route_tables" {
  for_each = toset(var.target_route_table_route_rules)

  name                   = each.value.rule_name
  resource_group_name    = each.value.route_table_resource_group_name
  route_table_name       = each.value.route_table_name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
}