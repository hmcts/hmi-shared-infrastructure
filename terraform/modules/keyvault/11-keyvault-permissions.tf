resource "azurerm_key_vault_access_policy" "sp_permissions" {
  key_vault_id            = data.azurerm_key_vault.shared_kv.id
  tenant_id               = var.tenant_id
  object_id               = var.principal_id
  certificate_permissions = var.certificate_permissions
  key_permissions         = var.key_permissions
  secret_permissions      = var.secret_permissions
  storage_permissions     = var.storage_permissions
}