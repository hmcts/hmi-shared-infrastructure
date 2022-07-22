variable "name" {
  type = string
}
variable "env" {
  type = string
}
variable "resource_group" {
  type = string
}
variable "location" {
  type = string
}
variable "common_tags" {
  type        = map(string)
  description = "Tags for the Azure resources"
}

variable "automation_account_sku_name" {
  type        = string
  description = "Azure ad SKU name"
  default     = "Basic"
  validation {
    condition     = contains(["Basic"], var.automation_account_sku_name)
    error_message = "Azure Automation Account SKUs are limited to Basic."
  }
}

variable "sas_tokens" {
  type = map(object({
    permissions     = string
    storage_account = string
    container       = string
    blob            = string
    expiry_date     = string
  }))
  description = "List of all of the SAS tokens to be created"
  default     = {}
}