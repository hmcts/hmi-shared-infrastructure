# Generic locals
locals {
  common_tags                      = module.ctags.common_tags
  resource_group_name              = "${var.product}-sharedservices-${var.environment}-rg"
  key_vault_name                   = "${var.product}-shared-kv-${var.environment}"
  shared_storage_name              = "hmisharedinfrasa"
  shared_infra_resource_group_name = "hmi-sharedinfra-${var.environment}-rg"
  certificate_name                 = "star-sandbox"
}

module "ctags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.environment
  product     = "hmi"
  builtFrom   = var.builtFrom
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

module "kv" {
  source                  = "git::https://github.com/hmcts/cnp-module-key-vault?ref=master"
  name                    = local.key_vault_name
  product                 = var.product
  env                     = var.environment
  object_id               = "b085c529-1b29-4075-969c-32ebfaddb1e4" ##TODO: get from KV or other place
  resource_group_name     = local.resource_group_name
  product_group_name      = var.active_directory_group
  common_tags             = local.common_tags
  create_managed_identity = true
}
