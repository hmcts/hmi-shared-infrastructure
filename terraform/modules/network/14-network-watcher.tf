data "azurerm_network_watcher" "network_watcher" {
  name                = "NetworkWatcher_${var.location}"
  resource_group_name = "NetworkWatcherRG"
}

data "azurerm_log_analytics_workspace" "hmcts" {
  provider            = azurerm.log-analytics-subscription
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_rg
}

# resource "azurerm_network_watcher_flow_log" "network_watcher_flow" {
#   network_watcher_name = data.azurerm_network_watcher.network_watcher.name
#   resource_group_name  = data.azurerm_resource_group.network_watcher.name

#   network_security_group_id = azurerm_network_security_group.apim_nsg.id
#   storage_account_id        = azurerm_storage_account.test.id
#   enabled                   = true

#   retention_policy {
#     enabled = true
#     days    = 7
#   }

#   traffic_analytics {
#     enabled               = true
#     workspace_id          = azurerm_log_analytics_workspace.test.workspace_id
#     workspace_region      = azurerm_log_analytics_workspace.test.location
#     workspace_resource_id = azurerm_log_analytics_workspace.test.id
#     interval_in_minutes   = 10
#   }
# }