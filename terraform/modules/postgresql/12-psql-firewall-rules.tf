
#  Remove Rule
  resource "azurerm_postgresql_firewall_rule" "allow_all_azure" {
    name                = "azure"
    resource_group_name = var.resource_group
    server_name         = azurerm_postgresql_server.hmi_pact.name
    start_ip_address    = "0.0.0.0"
    end_ip_address      = "0.0.0.0"
  } 
