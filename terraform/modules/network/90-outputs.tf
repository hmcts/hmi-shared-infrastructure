output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "apim_subnet_id" {
  value = azurerm_subnet.apim_subnet.id
}

output "mgmt_subnet_id" {
  value = azurerm_subnet.mgmt_subnet.id
}

output "watcher" {
  value = data.azurerm_network_watcher.network_watcher.name
}

output "la" {
  value = data.azurerm_log_analytics_workspace.hmcts.name
}