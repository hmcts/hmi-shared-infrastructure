resource "azurerm_logic_app_workflow" "hmi_la_dturota" {
  name                = "hmi-la-dturota-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group

  tags = var.common_tags
}

resource "azurerm_logic_app_workflow" "hmi_la_sittingpattern_publisher" {
  name                = "hmi-la-sittingpattern-publisher-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group

  tags = var.common_tags
}

resource "azurerm_logic_app_workflow" "hmi_la_sittingpattern_retriever" {
  name                = "hmi-la-sittingpattern-retriever-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group

  tags = var.common_tags
}

data "azurerm_client_config" "current" {}
data "azurerm_storage_account" "hmidtu" {
  name                = "hmidtu${var.env}"
  resource_group_name = var.resource_group
}

resource "azurerm_api_connection" "azureblob" {
  name                = "azureblob"
  resource_group_name = var.resource_group
  managed_api_id      = "subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Web/locations/${var.location}/managedApis/azureblob"
  display_name        = "HMI DTU Rota"
  parameter_values = {
    accountName = data.azurerm_storage_account.hmidtu.name
    accessKey   = data.azurerm_storage_account.hmidtu.primary_access_key
  }

  tags = var.common_tags
}

resource "azurerm_api_connection" "keyvault" {
  name                = "keyvault"
  resource_group_name = var.resource_group
  managed_api_id      = "subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Web/locations/${var.location}/managedApis/keyvault"
  display_name        = "HMI Key Vault"
  parameter_values = {
    /* "token:clientId"     = "#{keyVaultUserId}#",
    "token:clientSecret" = "#{keyVaultUserSecret}#",
    "token:TenantId"     = data.azurerm_client_config.current.tenant_id,
    "token:grantType"    = "client_credentials", */
    "vaultName"          = "hmi-shared-kv-${var.env}"
  }

  tags = var.common_tags
}

resource "azurerm_api_connection" "azuretables" {
  name                = "azuretables"
  resource_group_name = var.resource_group
  managed_api_id      = "subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Web/locations/${var.location}/managedApis/azuretables"
  display_name        = "HMI DTU Rota"
  parameter_values = {
    storageaccount = data.azurerm_storage_account.hmidtu.name
    sharedKey      = data.azurerm_storage_account.hmidtu.primary_access_key
  }

  tags = var.common_tags
}