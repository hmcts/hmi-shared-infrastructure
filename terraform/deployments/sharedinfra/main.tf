data "azurerm_resource_group" "hmi" {
  name = "hmi-sharedinfra-${var.environment}-rg"
}

data "azurerm_virtual_network" "hmi" {
  name                = "hmi-sharedinfra-vnet-${var.environment}"
  resource_group_name = data.azurerm_resource_group.hmi.name
}

module "network" {
  source                        = "../../modules/network"
  environment                   = var.environment
  resource_group                = var.resource_group
  project                       = var.project
  location                      = var.location
  address_space                 = var.address_space
  subnet_address_prefixes       = var.subnet_address_prefixes
  apim_nsg_rules                = var.apim_nsg_rules
  apim_rules                    = var.apim_rules
  route_table                   = var.route_table
  tags                          = local.common_tags
  log_analytics_workspace_name  = var.log_analytics_workspace_name
  log_analytics_workspace_rg    = var.log_analytics_workspace_rg
  log_analytics_subscription_id = var.log_analytics_subscription_id
}

module "postgresql" {
  source         = "../../modules/postgresql"
  environment    = var.environment
  resource_group = var.resource_group
  location       = var.location
  project        = var.project
  tags           = local.common_tags
  subnet_id      = module.network.apim_subnet_id
}

module "app-insights" {
  source         = "../../modules/app-insights"
  environment    = var.environment
  resource_group = var.resource_group
  location       = var.location
  project        = var.project
  support_email  = var.support_email
  ping_tests     = var.ping_tests
  tags           = local.common_tags
}

module "storage" {
  source = "../../modules/storage-account"

  env                 = var.environment
  resource_group_name = var.resource_group
  location            = var.location
  common_tags         = local.common_tags
}
