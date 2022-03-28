#tfsec:ignore:azure-storage-use-secure-tls-policy
module "sa" {
  source = "git::https://github.com/hmcts/cnp-module-storage-account.git?ref=master"
  #source = "../../../cnp-module-storage-account"

  env = var.env

  storage_account_name     = "hmisharedinfrasa${var.env}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.sa_account_tier
  account_kind             = var.sa_account_kind
  account_replication_type = var.sa_account_replication_type
  access_tier              = var.sa_access_tier

  team_name    = "HMI DevOps"
  team_contact = "#vh-devops"

  common_tags = var.common_tags
}

# module "sa_apim" {
#   source = "git::https://github.com/hmcts/cnp-module-storage-account.git?ref=master"
#   #source = "../../../cnp-module-storage-account"

#   env = var.env

#   storage_account_name            = "hmiapiminfra${var.env}sa"
#   resource_group_name             = var.resource_group_name
#   allow_nested_items_to_be_public = "true"
#   location                        = var.location
#   account_tier                    = "Standard"  # var.sa_account_tier
#   account_kind                    = "StorageV2" # var.sa_account_kind
#   account_replication_type        = "RAGRS"     # var.sa_account_replication_type
#   access_tier                     = "Hot"       # var.sa_access_tier
#   default_action                  = "Allow"
#   containers = [
#     {
#       name        = "hmiapimterraform",
#       access_type = "private"
#     }
#   ]
#   team_name    = "HMI DevOps"
#   team_contact = "#vh-devops"

#   common_tags = var.common_tags
# }