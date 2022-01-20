resource "random_password" "pact_db_password" {
  length      = 20
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
}

resource "azurerm_postgresql_server" "hmi_pact" {
  name                = "${var.product}-pact-broker-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.common_tags

  sku_name = "GP_Gen5_2" # required for network

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  administrator_login              = "pactadmin"
  administrator_login_password     = random_password.pact_db_password.result
  version                          = "10"
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
  public_network_access_enabled    = false
}

locals {
  settings_on  = ["log_checkpoints", "connection_throttling", "log_connections"]
  settings_off = []
}
resource "azurerm_postgresql_configuration" "hmi_pact_config_on" {
  for_each            = { for settings_on in local.settings_on : settings_on => settings_on }
  name                = each.value
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.hmi_pact.name
  value               = "on"
}
resource "azurerm_postgresql_configuration" "hmi_pact_config_off" {
  for_each            = { for settings_off in local.settings_off : settings_off => settings_off }
  name                = each.value
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.hmi_pact.name
  value               = "off"
}