module "aks-mi" {
  source = "../../modules/managed-identity/data"

  managed_identity_name = "aks-${var.environment}-mi"
  resource_group_name   = "genesis-rg"
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
    "aks-${var.environment}-mi" = {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = module.aks-mi.principal_id
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
