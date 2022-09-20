
# Created and Added via the HMI APIM Pipeline... will need moving over
module "hmidtu" {
  source = "../../modules/storage-account/data"

  storage_account_name = "hmidtu${var.environment}"
  resource_group_name  = data.azurerm_resource_group.hmi.name
}

module "keyvault_secrets" {
  source = "../../modules/key-vault/secret"

  key_vault_id = module.kv.key_vault_id
  tags         = local.common_tags
  secrets = [
    {
      name         = "appins-resource-id"
      value        = module.app-insights.id
      tags         = {}
      content_type = ""
    },
    {
      name         = "appins-instrumentation-key"
      value        = module.app-insights.instrumentation_key
      tags         = {}
      content_type = ""
    },
    {
      name         = "hmisharedinfrasa-storageaccount-key"
      value        = module.storage.primary_access_key
      tags         = {}
      content_type = ""
    },
    {
      name         = "hmisharedinfrasa-storageaccount-name"
      value        = "hmisharedinfrasa"
      tags         = {}
      content_type = ""
    },
    {
      name         = "dtu-storage-account-key"
      value        = module.hmidtu.primary_access_key
      tags         = {}
      content_type = ""
    },
    {
      name  = "HMI-APIM-BUILD-${upper(var.environment)}-json"
      value = var.variable_group_json_path == "" ? "" : file(var.variable_group_json_path)
      tags = {
        "source" = "https://dev.azure.com/hmcts/Shared$20Services/_library?itemType=VariableGroups&view=VariableGroupView&path=HMI-APIM-BUILD-${upper(var.environment)}"
      }
      content_type = "json"
    },
    {
      name  = "policy-variables-${var.environment}-json"
      value = var.secure_file_json_path == "" ? "" : file(var.secure_file_json_path)
      tags = {
        "source" = "https://dev.azure.com/hmcts/Shared%20Services/_library?itemType=SecureFiles&s=policy-variables-${var.environment}-json"
      }
      content_type = "json"
    },
    {
      name         = "hmi-servicenow-client"
      value        = var.service_now_client
      tags         = {}
      content_type = ""
    },
    {
      name         = "hmi-servicenow-secret"
      value        = var.service_now_secret
      tags         = {}
      content_type = ""
    }
  ]

  depends_on = [
    module.keyvault-policy,
  ]
}

module "keyvault_ado_secrets" {
  source = "../../modules/key-vault/secret"

  key_vault_id = module.kv.key_vault_id
  tags         = local.common_tags
  secrets = [
    for secret in var.secrets_arr : {
      name  = secret.name
      value = secret.value
      tags = {
        "source" : "ado library"
      }
      content_type = ""
    }
  ]
  depends_on = [
    module.keyvault-policy,
  ]
}