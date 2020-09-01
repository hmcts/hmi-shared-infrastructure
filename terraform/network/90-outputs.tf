output "out_network_vnet_id" {
  value = "${azurerm_virtual_network.vnet.id}"
}

output "out_network_subnet_id" {
  value = "${azurerm_subnet.apim_subnet.id}"
}

# output "out_network_nsg_id" {
#   value = "${azurerm_network_security_group.nsg.id}"
# }