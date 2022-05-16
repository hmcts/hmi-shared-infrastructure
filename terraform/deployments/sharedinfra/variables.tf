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
variable "address_space" {}
variable "subnet_address_prefixes" {}
variable "apim_nsg_rules" {}
variable "apim_rules" {}
variable "log_analytics_workspace_name" {}
variable "log_analytics_workspace_rg" {}
variable "log_analytics_subscription_id" {}

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
# Generic locals
locals {
  common_tags                      = module.ctags.common_tags
  key_vault_name                   = "${var.product}-shared-kv-${var.environment}"
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