resource "azurerm_network_security_group" "apim_nsg" {
  name                = "${var.product}-nsg-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group
  tags                = var.tags
}

resource "azurerm_network_security_rule" "apim_nsg_rules" {
  count                       = length(var.apim_nsg_rules)
  name                        = lookup(var.apim_nsg_rules[count.index], "name")
  priority                    = lookup(var.apim_nsg_rules[count.index], "priority", "${100 + (count.index + 10)}")
  direction                   = element(var.apim_rules["${lookup(var.apim_nsg_rules[count.index], "name")}"], 0)
  access                      = element(var.apim_rules["${lookup(var.apim_nsg_rules[count.index], "name")}"], 1)
  protocol                    = element(var.apim_rules["${lookup(var.apim_nsg_rules[count.index], "name")}"], 2)
  source_port_range           = element(var.apim_rules["${lookup(var.apim_nsg_rules[count.index], "name")}"], 3)
  destination_port_range      = element(var.apim_rules["${lookup(var.apim_nsg_rules[count.index], "name")}"], 4)
  source_address_prefix       = element(var.apim_rules["${lookup(var.apim_nsg_rules[count.index], "name")}"], 5)
  destination_address_prefix  = element(var.apim_rules["${lookup(var.apim_nsg_rules[count.index], "name")}"], 6)
  resource_group_name         = var.resource_group
  network_security_group_name = azurerm_network_security_group.apim_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "apim_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.apim_subnet.id
  network_security_group_id = azurerm_network_security_group.apim_nsg.id
}
