output "principal_id" {
  value = data.azurerm_user_assigned_identity.mi.principal_id
}
output "client_id" {
  value = data.azurerm_user_assigned_identity.mi.client_id
}