
resource "azurerm_key_vault_secret" "secret" {
  count        = length(var.secrets)
  key_vault_id = var.key_vault_id
  name         = var.secrets[count.index].name
  value        = var.secrets[count.index].value
  tags         = var.tags
}