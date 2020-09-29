resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}

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
  administrator_login_password = random_password.password.result
  version                      = "10"
  ssl_enforcement_enabled      = true
}

resource "azurerm_key_vault_secret" "pact-db-user" {
  name         = "pact-db-user"
  value        = azurerm_postgresql_server.hmi_pact.administrator_login
  key_vault_id = var.sharedinfra_kv
  tags         = var.tags
}

resource "azurerm_key_vault_secret" "pact-db-password" {
  name         = "pact-db-password"
  value        = azurerm_postgresql_server.hmi_pact.administrator_login_password
  key_vault_id = var.sharedinfra_kv
  tags         = var.tags
}
