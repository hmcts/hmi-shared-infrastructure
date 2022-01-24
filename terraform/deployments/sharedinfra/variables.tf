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
variable "target_route_table_route_rules" {
  description = "Target Route Table to add rules to it"
  type = map(object({
    route_table_name                = string
    route_table_resource_group_name = string
    rule_name                       = string
    address_prefix                  = string
    next_hop_type                   = string
    next_hop_in_ip_address          = string
  }))
  default = {}
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

# Generic locals
locals {
  common_tags = module.ctags.common_tags
}

module "ctags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.environment
  product     = "hmi"
  builtFrom   = var.builtFrom
}