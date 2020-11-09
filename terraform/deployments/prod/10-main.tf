module "network" {
  source                  = "../../modules/network"
  environment             = var.environment
  resource_group          = var.resource_group
  product                 = var.product
  location                = var.location
  address_space           = var.address_space
  subnet_address_prefixes = var.subnet_address_prefixes
  apim_nsg_rules          = var.apim_nsg_rules
  apim_rules              = var.apim_rules
  route_table             = var.route_table
  tags                    = var.tags
}
