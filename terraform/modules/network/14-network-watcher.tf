#tfsec:ignore:azure-storage-default-action-deny
resource "azurerm_storage_account" "network_watcher_storage" {
  name                            = "hmiapimwatcher${var.environment}"
  resource_group_name             = var.resource_group
  location                        = var.location
  allow_nested_items_to_be_public = "false"
  account_tier                    = "Standard"
  account_kind                    = "StorageV2"
  account_replication_type        = "LRS"
  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"

  tags = var.tags
}

resource "azurerm_network_watcher_flow_log" "network_watcher_flow" {
  network_watcher_name = data.azurerm_network_watcher.network_watcher.name
  resource_group_name  = data.azurerm_network_watcher.network_watcher.resource_group_name
  name                 = "Microsoft.Networkhmi-sharedinfra-${var.environment}-rghmi-sharedinfra-nsg-${var.environment}"
  location             = var.location

  network_security_group_id = azurerm_network_security_group.apim_nsg.id
  storage_account_id        = azurerm_storage_account.network_watcher_storage.id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = var.environment == "sbox" || var.environment == "dev" || var.environment == "test" ? 30 : 90
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = data.azurerm_log_analytics_workspace.hmcts.workspace_id
    workspace_region      = data.azurerm_log_analytics_workspace.hmcts.location
    workspace_resource_id = data.azurerm_log_analytics_workspace.hmcts.id
    interval_in_minutes   = var.environment == "sbox" || var.environment == "dev" || var.environment == "test" ? 60 : 10
  }
}
