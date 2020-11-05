resource "azurerm_application_insights" "app_insights" {
  name                = "${var.product}-appins-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group
  tags                = var.tags
  application_type    = "other"
  retention_in_days   = var.environment == "sbox" || var.environment == "dev" || var.environment == "test" ? 30 : 60
}