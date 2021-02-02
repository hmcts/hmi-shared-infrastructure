resource "azurerm_monitor_action_group" "hmi-action-group" {
  name                = "hmi-support"
  resource_group_name = var.resource_group
  short_name          = "hmi-support"

  email_receiver {
    name          = "HMI Support Mailing List"
    email_address = var.support_email
  }

  tags = var.tags
}