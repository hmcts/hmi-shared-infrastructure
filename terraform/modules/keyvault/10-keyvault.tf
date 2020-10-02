locals {
  database_name = "hmi-sharedservices-kv-${var.environment}"
  database_rg   = "hmi-sharedservices-${var.environment}-rg"
}

data "azurerm_key_vault" "shared_kv" {
  name                = local.database_name.value
  resource_group_name = local.database_rg.value
}
