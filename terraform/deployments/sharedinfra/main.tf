data "azurerm_resource_group" "hmi" {
  name = "hmi-sharedinfra-${var.environment}-rg"
}

module "network" {
  source                  = "../../modules/network"
  environment             = var.environment
  resource_group          = var.resource_group
  project                 = var.project
  location                = var.location
  address_space           = var.address_space
  subnet_address_prefixes = var.subnet_address_prefixes
  apim_nsg_rules          = var.apim_nsg_rules
  apim_rules              = var.apim_rules
  route_table             = flatten(var.route_table)

  log_analytics_workspace_name  = var.log_analytics_workspace_name
  log_analytics_workspace_rg    = var.log_analytics_workspace_rg
  log_analytics_subscription_id = var.log_analytics_subscription_id

  network_client_id     = var.network_client_id
  network_client_secret = var.network_client_secret
  network_tenant_id     = var.network_tenant_id

  tags = local.common_tags
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

data "azurerm_client_config" "current" {}

module "kv" {
  source                  = "git::https://github.com/hmcts/cnp-module-key-vault?ref=master"
  name                    = local.key_vault_name
  product                 = var.product
  env                     = var.environment
  object_id               = "b085c529-1b29-4075-969c-32ebfaddb1e4" ##TODO: get from KV or other place 
  resource_group_name     = data.azurerm_resource_group.hmi.name
  product_group_name      = var.active_directory_group #"DTS HMI"
  common_tags             = local.common_tags
  create_managed_identity = true
}

module "automation" {
  source         = "../../modules/automation"
  name           = "hmi-automation-${var.environment}"
  env            = var.environment
  resource_group = var.resource_group
  location       = var.location
  common_tags    = local.common_tags
  sas_tokens = {
    "rota-rl" = {
      permissions     = "rl"
      storage_account = "hmidtu${var.environment}"
      container       = "rota"
      blob            = ""
      expiry_date     = timeadd(timestamp(), "167h")
    },
    "rota-rlw" = {
      permissions     = "rlw"
      storage_account = "hmidtu${var.environment}"
      container       = "rota"
      blob            = ""
      expiry_date     = timeadd(timestamp(), "167h")
    }
  }

  depends_on = [
    module.storage,
    module.network
  ]
}

module "logicapp" {
  source                = "../../modules/logic-app"
  env                   = var.environment
  resource_group        = var.resource_group
  location              = var.location
  common_tags           = local.common_tags
  current_client_secret = var.current_client_secret
  current_client_id     = var.current_client_id
}