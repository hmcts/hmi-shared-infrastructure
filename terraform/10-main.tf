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
  route_name              = var.route_name
  route_address_prefix    = var.route_address_prefix
  route_next_hop_type     = var.route_next_hop_type
  next_hop_in_ip_address  = var.next_hop_in_ip_address
}