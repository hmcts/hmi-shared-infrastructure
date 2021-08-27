module "aks-mi" {
  source = "../../modules/managed-identity/data"

  managed_identity_name = "aks-${var.environment}-mi"
  resource_group_name   = "genesis-rg"
}
data "azuread_service_principal" "dcd_sp_ado" {
  display_name = "dcd_sp_ado_${var.environment}_operations_v2"
}
locals {
  apimName = "hmi-apim-svc-${var.environment}"
}
data "azurerm_api_management" "hmi_apim_svc" {
  name                = local.apimName
  resource_group_name = "hmi-apim-${var.environment}-rg"
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
      object_id               = data.azuread_application.cft_client.object_id #TODO: get id from data source e7214bce-c8df-4d67-b081-1def53db25a7
      key_permissions         = []
      secret_permissions      = ["get"]
      certificate_permissions = []
      storage_permissions     = []
    },
    "aks-sbox-mi" = {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = module.aks-mi.principal_id
      key_permissions         = []
      secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
      certificate_permissions = []
      storage_permissions     = []
    },
    "${data.azuread_service_principal.dcd_sp_ado.display_name}" = {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azuread_service_principal.dcd_sp_ado.object_id
      key_permissions         = []
      secret_permissions      = ["backup", "delete", "get", "list", "purge", "recover", "restore", "set"]
      certificate_permissions = ["purge", "backup", "create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers", "managecontacts", "manageissuers", "setissuers", "update"]
      storage_permissions     = []
    },
    "${local.apimName}" = {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azurerm_api_management.hmi_apim_svc.identity.0.principal_id
      key_permissions         = []
      secret_permissions      = ["Get", "Set", "List", "Delete"]
      certificate_permissions = []
      storage_permissions     = []
    }
  }
}
