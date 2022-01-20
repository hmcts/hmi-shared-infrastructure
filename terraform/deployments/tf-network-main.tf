data "azurerm_virtual_network" "hmi" {
  name                = "hmi-sharedinfra-vnet-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
}

module "network" {
  source                        = "../modules/network"
  environment                   = var.environment
  resource_group                = azurerm_resource_group.rg.name
  project                       = var.product
  location                      = azurerm_resource_group.rg.location
  address_space                 = var.address_space
  subnet_address_prefixes       = var.subnet_address_prefixes
  apim_nsg_rules                = var.apim_nsg_rules
  apim_rules                    = var.apim_rules
  route_table                   = var.route_table
  tags                          = local.common_tags
  log_analytics_workspace_name  = var.log_analytics_workspace_name
  log_analytics_workspace_rg    = var.log_analytics_workspace_rg
  log_analytics_subscription_id = var.log_analytics_subscription_id

  network_client_id     = var.network_client_id
  network_client_secret = var.network_client_secret
  network_tenant_id     = var.network_tenant_id
}