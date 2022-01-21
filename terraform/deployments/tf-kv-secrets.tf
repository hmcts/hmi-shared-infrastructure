

data "azurerm_application_insights" "appin" {
  name                = "hmi-sharedinfra-appins-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
}

module "keyvault_secrets" {
  source = "../modules/key-vault/secret"

  key_vault_id = module.kv.key_vault_id
  tags         = local.common_tags
  secrets = [
    {
      name         = "appins-instrumentation-key"
      value        = data.azurerm_application_insights.appin.instrumentation_key
      tags         = {}
      content_type = ""
    },
    {
      name         = "${module.sa_shared.storageaccount_name}-storageaccount-key"
      value        = module.sa_shared.storageaccount_primary_access_key
      tags         = {}
      content_type = ""
    },
    {
      name         = "${module.sa_shared.storageaccount_name}-storageaccount-name"
      value        = module.sa_shared.storageaccount_name
      tags         = {}
      content_type = ""
    },
    {
      name         = "dtu-storage-account-key"
      value        = module.sa_dtu.storageaccount_primary_access_key
      tags         = {}
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
    /* {
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
    }, */
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

}