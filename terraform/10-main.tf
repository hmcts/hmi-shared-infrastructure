module "network" {
  source                  = "./network"
  environment             = var.environment
  resource_group          = var.resource_group
  product                 = var.product
  location                = var.location
  address_space           = var.address_space
  subnet_address_prefixes = var.subnet_address_prefixes
  service_endpoints       = var.service_endpoints
  subnet_delegation       = var.subnet_delegation
  apim_nsg_rules          = var.apim_nsg_rules
  apim_rules              = var.apim_rules
  tags                    = var.tags
  route_table             = var.route_table
}
