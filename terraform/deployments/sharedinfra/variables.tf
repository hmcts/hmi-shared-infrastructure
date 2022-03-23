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
variable "sp_object_id" {
  type        = string
  description = "Service principal object id"
}
# Generic locals
locals {
  common_tags                      = module.ctags.common_tags
  key_vault_name                   = "${var.product}-shared-kv-${var.environment}"
  shared_storage_name              = "hmisharedinfrasa"
  shared_infra_resource_group_name = "hmi-sharedinfra-${var.environment}-rg"
}

module "ctags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.environment
  product     = "hmi"
  builtFrom   = var.builtFrom
}
