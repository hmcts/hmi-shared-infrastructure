resource "azurerm_key_vault" "key_vault" {
  name                       = "${var.product}-kv-${var.environment}"
  location                   = var.location
  resource_group_name        = var.resource_group
  tenant_id                  = var.tenant_id
  sku_name                   = var.sku_name
  soft_delete_enabled        = true
  soft_delete_retention_days = 90
  tags                       = var.tags
}
