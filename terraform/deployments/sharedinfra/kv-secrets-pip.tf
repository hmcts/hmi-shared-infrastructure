locals {
  pip_env     = var.environment != "prod" ? "stg" : var.environment
  pip_rg_name = "pip-ss-${local.pip_env}-rg"
  pip_kv_name = "pip-ss-apim-kv-${local.pip_env}"
}


data "azurerm_key_vault" "pip_kv" {
  name                = local.pip_kv_name
  resource_group_name = local.pip_rg_name
}


data "azurerm_key_vault_secret" "pip_tenant_id" {
  name         = "app-tenat-id"
  key_vault_id = data.azurerm_key_vault.pip_kv.id
}

data "azurerm_key_vault_secret" "hmi_client_pwd" {
  name         = "app-pip-apim-hmi-pwd"
  key_vault_id = data.azurerm_key_vault.pip_kv.id
}
data "azurerm_key_vault_secret" "hmi_client_id" {
  name         = "app-pip-apim-hmi-id"
  key_vault_id = data.azurerm_key_vault.pip_kv.id
}

data "azurerm_key_vault_secret" "data_client_scope" {
  name         = "app-pip-data-management-scope"
  key_vault_id = data.azurerm_key_vault.pip_kv.id
}

module "keyvault_secrets_pip" {
  source = "../../modules/key-vault/secret"

  key_vault_id = module.kv.key_vault_id
  tags         = local.common_tags
  secrets = [
    {
      name  = "pip-tenant-id"
      value = data.azurerm_key_vault_secret.pip_tenant_id.value
      tags = {
        "source" = "pip apim vault - ${local.pip_kv_name}"
      }
      content_type = ""
    },
    {
      name  = "pip-client-id"
      value = data.azurerm_key_vault_secret.hmi_client_id.value
      tags = {
        "source" = "pip apim vault - ${local.pip_kv_name}"
      }
      content_type = ""
    },
    {
      name  = "pip-client-pwd"
      value = data.azurerm_key_vault_secret.hmi_client_pwd.value
      tags = {
        "source" = "pip apim vault - ${local.pip_kv_name}"
      }
      content_type = ""
    },
    {
      name  = "pip-data-mgnt-scope"
      value = data.azurerm_key_vault_secret.data_client_scope.value
      tags = {
        "source" = "pip apim vault - ${local.pip_kv_name}"
      }
      content_type = ""
    }
  ]

  depends_on = [
    module.keyvault-policy,
  ]
}