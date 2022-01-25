module "shared_storage" {
  source = "../../modules/storage-account/data"

  storage_account_name = "${local.shared_storage_name}${var.environment}"
  resource_group_name  = local.shared_infra_resource_group_name
}

module "hmidtu" {
  source = "../../modules/storage-account/data"

  storage_account_name = "hmidtu${var.environment}"
  resource_group_name  = local.shared_infra_resource_group_name
}

data "azurerm_storage_blob" "pact_db_password" {
  name                   = "pact_db_content"
  storage_account_name   = "hmiapiminfra${var.environment}sa"
  storage_container_name = "hmiapimterraform"
}
data "azurerm_application_insights" "appin" {
  name                = "hmi-sharedinfra-appins-${var.environment}"
  resource_group_name = local.shared_infra_resource_group_name
}

module "keyvault_secrets" {
  source = "../../modules/key-vault/secret"

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
      name         = "${local.shared_storage_name}-storageaccount-key"
      value        = module.shared_storage.primary_access_key
      tags         = {}
      content_type = ""
    },
    {
      name         = "${local.shared_storage_name}-storageaccount-name"
      value        = local.shared_storage_name
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
      name  = "pact-db-password"
      value = data.azurerm_storage_blob.pact_db_password.content_md5
      tags = {
        "file-encoding" = "md5"
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

}