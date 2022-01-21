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
variable "support_email" {
  type        = string
  description = "Email for Application insight alerts"
}
variable "ping_tests" {
  type = list(object({
    pingTestName = string
    pingTestURL  = string
    pingText     = string
  }))
  description = "Ping Test Settings"
}

variable "route_table" {
  default     = null
  description = "Networking Route Table"
}
variable "address_space" {
  type        = list(string)
  description = "Virtual Network Address Spacing"
}
variable "subnet_address_prefixes" {
  type        = list(string)
  description = "Virtual Network Subnet Address Spacing"
}

variable "apim_nsg_rules" {
  type = list(object({
    name = string
  }))
  description = "Network Security Group Rules"
}
variable "apim_rules" {
  type        = map(any)
  description = "Network Security Group Rule Rules"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Log Analaytice Workspace Name"
}
variable "log_analytics_workspace_rg" {
  type        = string
  description = "Log Analaytice Workspace Resource Group"
}
variable "log_analytics_subscription_id" {
  type        = string
  description = "Log Analaytice Workspace Subscription ID"
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

variable "active_directory_group" {
  type        = string
  description = "Active Directory Group Name"
  default     = "DTS HMI"
}

/* variable "secure_file_json_path" {
  type        = string
  description = "Exported Secure File JSON Path"
}
variable "variable_group_json_path" {
  type        = string
  description = "Exported Azure DevOps Variable Group JSON Path"
} */

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