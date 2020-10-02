data "azurerm_key_vault" "shared_kv" {
  name                = "hmi-sharedservices-kv-${var.environment}"
  resource_group_name = "hmi-sharedservices-${var.environment}-rg"
}