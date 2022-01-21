#tfsec:ignore:azure-keyvault-no-purge tfsec:ignore:azure-keyvault-specify-network-acl
module "kv" {
  source                  = "git::https://github.com/hmcts/cnp-module-key-vault?ref=master"
  name                    = local.key_vault_name
  product                 = var.product
  env                     = var.environment
  object_id               = data.azurerm_client_config.current.object_id
  resource_group_name     = local.resource_group_name
  product_group_name      = var.active_directory_group
  common_tags             = local.common_tags
  create_managed_identity = true
}