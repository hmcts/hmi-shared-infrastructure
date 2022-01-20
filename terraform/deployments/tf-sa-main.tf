
#tfsec:ignore:azure-storage-use-secure-tls-policy
module "sa_shared" {
  source = "git::https://github.com/hmcts/cnp-module-storage-account.git?ref=master"

  env = var.environment

  storage_account_name = "hmisharedinfrasa${var.environment}"
  common_tags          = local.common_tags

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  account_tier             = "Cool"
  account_kind             = "BlobStorage"
  account_replication_type = "Standard"
  access_tier              = "RAGRS"

  team_name    = "HMI DevOps"
  team_contact = "#vh-devops"
}

#tfsec:ignore:azure-storage-use-secure-tls-policy
module "sa_dtu" {
  source = "git::https://github.com/hmcts/cnp-module-storage-account.git?ref=master"

  env = var.environment

  storage_account_name = "hmidtu${var.environment}"
  common_tags          = local.common_tags

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  account_tier             = "Cool"
  account_kind             = "StorageV2"
  account_replication_type = "Standard"
  access_tier              = "LRS"

  team_name    = "HMI DevOps"
  team_contact = "#vh-devops"

  containers = [
    {
      name        = "rota"
      access_type = "private"
    },
    {
      name        = "sitting-pattern"
      access_type = "private"
    }
  ]
}