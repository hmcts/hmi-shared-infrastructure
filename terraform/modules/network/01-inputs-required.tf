variable "environment" {}
variable "resource_group" {}
variable "product" {}
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
