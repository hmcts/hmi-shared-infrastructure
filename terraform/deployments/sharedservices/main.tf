# Generic locals
locals {
  common_tags                      = module.ctags.common_tags
  resource_group_name              = "${var.product}-sharedservices-${var.environment}-rg"
  key_vault_name                   = "${var.product}-shared-kv-${var.environment}"
  casehqemulatorStorageName        = "casehqemulator"
  shared_infra_resource_group_name = "hmi-sharedinfra-${var.environment}-rg"
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

module "kv" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = local.key_vault_name
  product                 = var.product
  env                     = var.environment
  object_id               = "b085c529-1b29-4075-969c-32ebfaddb1e4" ##TODO: get from KV or other place
  resource_group_name     = local.resource_group_name
  product_group_name      = var.active_directory_group
  common_tags             = local.common_tags
  create_managed_identity = true
}

module "aks-mi" {
  source = "../../modules/managed-identity/data"

  managed_identity_name = "aks-${var.environment}-mi"
  resource_group_name   = "genesis-rg"
}
data "azuread_service_principal" "dcd_sp_ado" {
  display_name = "dcd_sp_ado_${var.environment}_operations_v2"
}
data "azuread_service_principal" "hmi_apim_svc" {
  display_name = "hmi-apim-svc-${var.environment}"
}

module "keyvault-policy" {
  source = "../../modules/key-vault/access-policy"

  key_vault_id = module.kv.key_vault_id

  policies = {
    "cft-client" = {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = "e7214bce-c8df-4d67-b081-1def53db25a7" #TODO: get id from data source
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
      secret_permissions      = ["List", "Purge", "Restore", "Get", "Set", "Delete", "Backup", "Recover"]
      certificate_permissions = []
      storage_permissions     = []
    },
    "${data.azuread_service_principal.hmi_apim_svc.display_name}" = {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azuread_service_principal.hmi_apim_svc.object_id
      key_permissions         = []
      secret_permissions      = ["Get", "Set", "List", "Delete"]
      certificate_permissions = []
      storage_permissions     = []
    }
  }
}


module "case-hq-emulator" {
  source = "../../modules/storage-account/data"

  storage_account_name = "${local.casehqemulatorStorageName}${var.environment}"
  resource_group_name  = local.shared_infra_resource_group_name
}
module "hmidtu" {
  source = "../../modules/storage-account/data"

  storage_account_name = "hmidtu${var.environment}"
  resource_group_name  = local.shared_infra_resource_group_name
}
# Generate a random password
resource "random_password" "pact-db-password" {
  length      = 20
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
}
data "azurerm_application_insights" "appin" {
  name                = "hmi-sharedinfra-appins-${var.environment}"
  resource_group_name = local.shared_infra_resource_group_name
}

module "keyvault-secrets" {
  source = "../../modules/key-vault/secret"

  key_vault_id = module.kv.key_vault_id
  tags         = local.common_tags
  secrets = [
    {
      name  = "appins-instrumentation-key"
      value = data.azurerm_application_insights.appin.instrumentation_key
      tags  = {}
      content_type = ""
    },
    {
      name  = "${local.casehqemulatorStorageName}-storageaccount-key"
      value = module.case-hq-emulator.primary_access_key
      tags  = {}
      content_type = ""
    },
    {
      name  = "${local.casehqemulatorStorageName}-storageaccount-name"
      value = local.casehqemulatorStorageName
      tags  = {}
      content_type = ""
    },
    {
      name  = "dtu-storage-account-key"
      value = module.hmidtu.primary_access_key
      tags  = {}
      content_type = ""
    },
    {
      name  = "pact-db-password"
      value = random_password.pact-db-password.result
      tags = {
        "file-encoding" = "utf-8"
        "purpose"       = "pactbrokerdb"
      }
      content_type = ""
    },
    {
      name  = "pact-db-user"
      value = "pactadmin"
      tags = {
        "file-encoding" = "utf-8"
        "purpose"       = "pactbrokerdb"
      }
      content_type = ""
    },
    {
      name = "HMI-APIM-BUILD-${upper(var.environment)}-json"
      value = var.variable_group_json
      tags = {
        "source" = "https://dev.azure.com/hmcts/Shared$20Services/_library?itemType=VariableGroups&view=VariableGroupView&path=HMI-APIM-BUILD-${upper(var.environment)}"
      }
      content_type = "json"
    },
    {
      name = "policy-variables-${var.environment}-json"
      value = var.secure_file_json
      tags = {
        "source" = "https://dev.azure.com/hmcts/Shared%20Services/_library?itemType=SecureFiles"
      }
      content_type = "json"
    }
  ]
}

module "keyvault-certificate" {
  source = "../../modules/key-vault/certificate"

  keyvault_id = module.kv.key_vault_id

  certificates = {
    "star-sandbox" = {
      name               = "star-sandbox"
      content            = filebase64(var.pfx_path)
      validity_in_months = 13
      key_usage = [
        "digitalSignature",
        "keyEncipherment"
      ]
      extended_key_usage = [
        "1.3.6.1.5.5.7.3.1",
        "1.3.6.1.5.5.7.3.2"
      ]

      key_properties_exportable = true
      key_properties_key_size   = 4096
      key_properties_key_type   = "RSA"
      key_properties_reuse_key  = false

      issuer_name = "Unknown"
      dns_names = [
        "*.sandbox.platform.hmcts.net",
        "sandbox.platform.hmcts.net",
      ]
      subject = "CN=*.sandbox.platform.hmcts.net"
    }
  }
}
