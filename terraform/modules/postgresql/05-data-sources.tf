data "azurerm_key_vault" "shared_kv" {
  name                = "hmi-sharedservices-kv-${var.environment}"
  resource_group_name = "hmi-sharedservices-${var.environment}-rg"
}

data "azurerm_key_vault_secret" "pact_password" {
  name         = "pact-db-password"
  key_vault_id = data.azurerm_key_vault.shared_kv.id
}
