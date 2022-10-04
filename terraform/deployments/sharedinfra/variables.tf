variable "environment" {}
variable "resource_group" {}
variable "project" {}
variable "location" {}
variable "support_email" {}
variable "ping_tests" {}
variable "builtFrom" {}

variable "route_table" {
  default = null
}
variable "cft_routing_rules" {
  default = null
}
variable "sds_routing_rules" {
  default = null
}
locals {
  route_table = {
    "sbox" = concat(var.route_table, var.sds_routing_rules["sbox"])
    "dev"  = concat(var.route_table, var.sds_routing_rules["dev"], var.sds_routing_rules["stg"])
    "test" = concat(var.route_table, var.sds_routing_rules["stg"], var.sds_routing_rules["test"])
    "stg"  = concat(var.route_table, var.sds_routing_rules["stg"], var.cft_routing_rules["aat"], var.cft_routing_rules["perftest"])
    "prod" = concat(var.route_table, var.sds_routing_rules["prod"])
    "ithc" = concat(var.route_table, var.cft_routing_rules["ithc"], var.cft_routing_rules["prod"], var.sds_routing_rules["ithc"])
  }
}

variable "address_space" {}
variable "subnet_address_prefixes" {}
variable "apim_nsg_rules" {}
variable "apim_rules" {}
variable "log_analytics_workspace_name" {}
variable "log_analytics_workspace_rg" {}
variable "log_analytics_subscription_id" {}

# Current Client Details
variable "current_client_id" {
  description = "Client ID of the Current SP"
  type        = string
  sensitive   = true
}
variable "current_client_secret" {
  description = "Client Secret of the Current SP"
  type        = string
  sensitive   = true
}

# Networking Client Details
variable "network_client_id" {
  description = "Client ID of the GlobalNetworkPeering SP"
  type        = string
}
variable "network_client_secret" {
  description = "Client Secret of the GlobalNetworkPeering SP"
  type        = string
  sensitive   = true
}
variable "network_tenant_id" {
  description = "Client Tenant ID of the GlobalNetworkPeering SP"
  type        = string
}
# KV
variable "active_directory_group" {
  type        = string
  description = "Active Directory Group Name"
  default     = "DTS HMI"
}
variable "product" {
  type        = string
  description = "Product Name"
  default     = "hmi"
}
variable "service_now_client" {
  type        = string
  description = "Service Now Client"
  sensitive   = true
}
variable "service_now_secret" {
  type        = string
  description = "Service Now Secret"
  sensitive   = true
}
variable "secure_file_json_path" {
  type        = string
  description = "Exported Secure File JSON Path"
}
variable "variable_group_json_path" {
  type        = string
  description = "Exported Azure DevOps Variable Group JSON Path"
}
variable "secrets_arr" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Key Vault Secrets from AzDO Library"
  #sensitive   = true
  default = []
}
# Generic locals
locals {
  common_tags    = module.ctags.common_tags
  key_vault_name = "${var.product}-shared-kv-${var.environment}"
}

module "ctags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.environment
  product     = "hmi"
  builtFrom   = var.builtFrom
}

variable "client_kv_mi_access" {
  type        = map(any)
  description = "Map of Managed Identities that should have GET access on Key Vault. name = app_name, value = mi client ID"
  default     = {}
}