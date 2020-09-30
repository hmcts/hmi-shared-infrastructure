resource "azurerm_key_vault_access_policy" "sp_permissions" {
  key_vault_id            = azurerm_key_vault.key_vault.id
  tenant_id               = azurerm_key_vault.key_vault.tenant_id
  object_id               = var.principal_id
  certificate_permissions = var.certificate_permissions
  key_permissions         = var.key_permissions
  secret_permissions      = var.secret_permissions
  storage_permissions     = var.storage_permissions
}