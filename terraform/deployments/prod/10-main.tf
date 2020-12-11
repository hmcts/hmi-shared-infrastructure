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
  sds_subcription_id            = var.sds_subcription_id
  log_analytics_subscription_id = var.la_sbox_sub_id
}

module "app-insights" {
  source         = "../../modules/app-insights"
  environment    = var.environment
  resource_group = var.resource_group
  location       = var.location
  product        = var.product
  tags           = var.tags
}
