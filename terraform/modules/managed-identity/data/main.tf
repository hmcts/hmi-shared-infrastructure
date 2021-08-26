
data "azurerm_user_assigned_identity" "mi" {
  name                = var.managed_identity_name
  resource_group_name = var.resource_group_name
}