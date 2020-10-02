data "azurerm_key_vault_secret" "pact_password" {
  name         = "pact-db-password"
  key_vault_id = var.keyvault_id
}
