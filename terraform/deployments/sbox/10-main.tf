module "network" {
  source                        = "../../modules/network"
  environment                   = var.environment
  resource_group                = var.resource_group
  product                       = var.product
  location                      = var.location
  address_space                 = var.address_space
  subnet_address_prefixes       = var.subnet_address_prefixes
  apim_nsg_rules                = var.apim_nsg_rules
  apim_rules                    = var.apim_rules
  route_table                   = var.route_table
  tags                          = var.tags
  log_analytics_workspace_name  = var.log_analytics_workspace_name
  log_analytics_workspace_rg    = var.log_analytics_workspace_rg
  log_analytics_subscription_id = var.la_sbox_sub_id
}

module "network_peering" {
  source = "git::https://github.com/hmcts/aks-module-network-peering.git"

  deploy_environment = var.environment
  network_location   = var.location

  requester_network_name                = data.azurerm_virtual_network.hmi.name
  requester_network_id                  = data.azurerm_virtual_network.hmi.id
  requester_network_resource_group_name = data.azurerm_resource_group.hmi.name

  accepter_network_name                = data.azurerm_virtual_network.aks.name
  accepter_network_id                  = data.azurerm_virtual_network.aks.id
  accepter_network_resource_group_name = data.azurerm_resource_group.aks.name
}

module "postgresql" {
  source         = "../../modules/postgresql"
  environment    = var.environment
  resource_group = var.resource_group
  location       = var.location
  product        = var.product
  tags           = var.tags
  subnet_id      = module.network.apim_subnet_id
}

module "app-insights" {
  source         = "../../modules/app-insights"
  environment    = var.environment
  resource_group = var.resource_group
  location       = var.location
  product        = var.product
  tags           = var.tags
}
