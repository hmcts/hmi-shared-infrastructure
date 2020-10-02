locals {
  database_name = "hmi-sharedservices-kv-${var.environment}"
  database_rg   = "hmi-sharedservices-${var.environment}-rg"
}

data "azurerm_key_vault" "shared_kv" {
  name                = local.database_name.value
  resource_group_name = local.database_rg.value
}

data "azurerm_key_vault_secret" "pact_password" {
  name         = "pact-db-password"
  key_vault_id = data.azurerm_key_vault.shared_kv.id
}
