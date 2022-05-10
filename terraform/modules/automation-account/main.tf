resource "azurerm_automation_account" "hmi-automation" {
	name = "hmi-automation-${var.environment}"
	location = var.location
	resource_group_name = var.resource_group
	sku_name = "Basic"

	tags = var.common_tags
}