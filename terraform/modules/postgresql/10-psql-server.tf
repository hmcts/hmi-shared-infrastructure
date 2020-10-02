resource "azurerm_postgresql_server" "hmi_pact" {
  name                = "hmi-pact-broker-${var.environment}"
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags

  sku_name = "GP_Gen5_2" # required for network

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  administrator_login          = "pactadmin"
  administrator_login_password = data.azurerm_key_vault_secret.pact_password.value
  version                      = "10"
  ssl_enforcement_enabled      = true
}
