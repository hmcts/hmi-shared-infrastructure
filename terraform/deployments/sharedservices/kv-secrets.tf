
module "case_hq_emulator" {
  source = "../../modules/storage-account/data"

  storage_account_name = "${local.casehqemulatorStorageName}${var.environment}"
  resource_group_name  = local.shared_infra_resource_group_name
}

module "hmidtu" {
  source = "../../modules/storage-account/data"

  storage_account_name = "hmidtu${var.environment}"
  resource_group_name  = local.shared_infra_resource_group_name
}

resource "random_password" "pact_db_password" {
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

data "azuread_service_principal" "ado_sp" {
  display_name = "DTS Service Principal (ado:docmosis/docmosis-container-build)"
}

resource "azuread_service_principal_password" "ado_sp_password" {
  display_name = "HMI Shared Services"
  service_principal_id = data.azuread_service_principal.ado_sp.id
  end_date = timeadd(timestamp(), "8760h")
}

data "azurerm_key_vault_certificate" "star_cert" {
  name         = local.certificate_name
  key_vault_id = module.kv.key_vault_id
}

module "keyvault_secrets" {
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
      value = module.case_hq_emulator.primary_access_key
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
      value = random_password.pact_db_password.result
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
      value = var.variable_group_json_path == "" ? "" : file(var.variable_group_json_path)
      tags = {
        "source" = "https://dev.azure.com/hmcts/Shared$20Services/_library?itemType=VariableGroups&view=VariableGroupView&path=HMI-APIM-BUILD-${upper(var.environment)}"
      }
      content_type = "json"
    },
    {
      name = "policy-variables-${var.environment}-json"
      value = var.secure_file_json_path == "" ? "" : file(var.secure_file_json_path)
      tags = {
        "source" = "https://dev.azure.com/hmcts/Shared%20Services/_library?itemType=SecureFiles&s=policy-variables-${var.environment}-json"
      }
      content_type = "json"
    },
    {
      name = "ado-sp-secret"
      value = resource.azuread_service_principal_password.ado_sp_password.value
      tags = {
        "source" = "DTS Service Principal (ado:docmosis/docmosis-container-build)"
      }
      content_type = ""
    },
    {
      name = "apim-hostname-certificate"
      value = data.azurerm_key_vault_certificate.star_cert.certificate_data_base64
      tags = {
        "source" = "cftapps-${var.environment}"
      }
      content_type = "application/x-pkcs12"
    }
  ]

  depends_on = [
    module.keyvault_certificate
  ]
}