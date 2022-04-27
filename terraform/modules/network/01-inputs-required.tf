variable "environment" {}
variable "resource_group" {}
variable "project" {}
variable "location" {}
variable "address_space" {}
variable "tags" {}
variable "subnet_address_prefixes" {}
variable "apim_nsg_rules" {}
variable "apim_rules" {}
variable "route_table" {}
variable "log_analytics_workspace_name" {}
variable "log_analytics_workspace_rg" {
  default = "oms-automation"
}

variable "log_analytics_subscription_id" {}

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

locals {
  network_watcher_storage_repl_type = var.environment == "sandbox" || var.environment == "stg" ? "LRS" : "ZRS"
}
