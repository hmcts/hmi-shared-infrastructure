# Generic locals
locals {
  common_tags         = module.ctags.common_tags
  key_vault_name      = "${var.product}-shared-kv-${var.environment}"
  shared_storage_name = "hmisharedinfrasa"
  resource_group_name = "${var.product}-sharedinfra-${var.environment}-rg"
}

module "ctags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.environment
  product     = var.product
  builtFrom   = var.builtFrom
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}
