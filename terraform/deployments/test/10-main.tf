module "keyvault" {
  source       = "../../modules/keyvault"
  environment  = var.environment
  tenant_id    = var.tenant_id
  principal_id = var.principal_id
}

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

module "postgresql" {
  source         = "../../modules/postgresql"
  environment    = var.environment
  resource_group = var.resource_group
  location       = var.location
  product        = var.product
  tags           = var.tags
  subnet_id      = module.network.apim_subnet_id
  keyvault_id    = module.keyvault.keyvault_id
}
