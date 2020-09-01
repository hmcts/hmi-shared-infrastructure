# resource "azurerm_network_security_group" "nsg" {
#   name                = "${var.product}-nsg-${var.environment}"
#   location            = var.location
#   resource_group_name = var.resource_group
#   tags                = var.tags
# }