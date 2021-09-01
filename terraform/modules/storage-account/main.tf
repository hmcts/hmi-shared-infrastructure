data "azurerm_client_config" "current" {
}

module "sa" {
  source = "git::https://github.com/hmcts/cnp-module-storage-account.git?ref=master"
  #source = "../../../cnp-module-storage-account"

  env = var.env

  storage_account_name = "hmisharedinfrasa${var.env}"
  common_tags          = var.common_tags

  resource_group_name = var.resource_group_name
  location            = var.location

  account_tier             = var.sa_account_tier
  account_kind             = var.sa_account_kind
  account_replication_type = var.sa_account_replication_type
  access_tier              = var.sa_access_tier

  team_name    = "HMI DevOps"
  team_contact = "#vh-devops"

  managed_identity_object_id = data.azurerm_client_config.current.object_id
  role_assignments = [
    "Storage Blob Data Contributor"
  ]

  containers = [
    {
      name        = "casehqemulator${var.env}"
      access_type = "private"
    }
  ]
}