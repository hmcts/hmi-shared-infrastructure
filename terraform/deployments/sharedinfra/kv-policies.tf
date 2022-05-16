data "azurerm_user_assigned_identity" "aks_mi" {
  name                = "aks-${var.environment}-mi"
  resource_group_name = "genesis-rg"
}

# DTS SDS Developers Group
data "azuread_group" "sds_dev" {
  object_id      = "7bde62e7-b39f-487c-95c9-b4c794fdbb96"
}

data "azuread_application" "cft_client" {
  display_name = "cft-client"
}

module "keyvault-policy" {
  source = "../../modules/key-vault/access-policy"

  key_vault_id = module.kv.key_vault_id

  policies = {
    "cft-client" = {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azuread_application.cft_client.object_id
      key_permissions         = []
      secret_permissions      = ["Get"]
      certificate_permissions = []
      storage_permissions     = []
    },
    "${replace(data.azuread_group.sds_dev.display_name, " ", "-")}" = {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azuread_group.sds_dev.object_id
      key_permissions         = []
      secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
      certificate_permissions = []
      storage_permissions     = []
    },
    "aks-${var.environment}-mi" = {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azurerm_user_assigned_identity.aks_mi.principal_id
      key_permissions         = []
      secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
      certificate_permissions = []
      storage_permissions     = []
    },
    "sp-${var.environment}" = {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azurerm_client_config.current.object_id
      key_permissions         = []
      secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
      certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "SetIssuers", "Update"]
      storage_permissions     = []
    }
  }
}


resource "azurerm_key_vault_access_policy" "client_access" {
  for_each = var.client_kv_mi_access

  key_vault_id = module.kv.key_vault_id

  object_id = each.value
  tenant_id = data.azurerm_client_config.current.tenant_id

  certificate_permissions = []
  key_permissions         = []
  secret_permissions = [
    "Get",
  ]
}