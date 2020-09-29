module "network" {
  source                  = "./network"
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

module "keyvault" {
  source         = "./keyvault"
  environment    = var.environment
  resource_group = var.resource_group
  location       = var.location
  product        = var.product
  tags           = var.tags
  tenant_id      = var.tenant_id
  principal_id   = var.principal_id
}

module "postgresql" {
  source           = "./postgresql"
  environment      = var.environment
  resource_group   = var.resource_group
  location         = var.location
  product          = var.product
  tags             = var.tags
  subnet_id        = module.network.apim_subnet_id
  sharedinfra_kv   = module.keyvault.keyvault_id
}
