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