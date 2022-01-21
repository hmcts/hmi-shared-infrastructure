##TODO: clean naming and organisation and descriptions
variable "environment" {
  type        = string
  description = "Deployment Environment"
}
variable "product" {
  type        = string
  description = "Product Name"
  default     = "hmi"
}
variable "builtFrom" {
  type        = string
  description = "Source of deployment"
  default     = "local"
}

variable "location" {
  type        = string
  description = "Resource Location"
}
variable "support_email" {}
variable "ping_tests" {}
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

variable "active_directory_group" {
  type        = string
  description = "Active Directory Group Name"
  default     = "DTS HMI"
}

variable "secure_file_json_path" {
  type        = string
  description = "Exported Secure File JSON Path"
}
variable "variable_group_json_path" {
  type        = string
  description = "Exported Azure DevOps Variable Group JSON Path"
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