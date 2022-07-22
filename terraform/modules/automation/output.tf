output "system_id" {
  value = azurerm_automation_account.hmi_automation.identity.0.principal_id
}