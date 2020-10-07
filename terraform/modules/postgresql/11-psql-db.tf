resource "azurerm_postgresql_database" "pact_db" {
  name                = "hmi-pactbroker"
  resource_group_name = var.resource_group
  server_name         = azurerm_postgresql_server.hmi_pact.name
  charset             = "UTF8"
  collation           = "en-GB"
}
