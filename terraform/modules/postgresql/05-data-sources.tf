data "azurerm_key_vault" "shared_kv" {
  name                = "hmi-shared-kv-${var.environment}"
  resource_group_name = "hmi-sharedservices-${var.environment}-rg"
}

data "azurerm_key_vault_secret" "pact_password" {
  name         = "pact-db-password"
  key_vault_id = data.azurerm_key_vault.shared_kv.id
}

data "azurerm_network_watcher" "network_watcher" {
  name                = "NetworkWatcher_${var.location}"
  resource_group_name = "NetworkWatcherRG"
}

data "azurerm_log_analytics_workspace" "hmcts" {
  provider            = azurerm.log-analytics-subscription
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_rg
}