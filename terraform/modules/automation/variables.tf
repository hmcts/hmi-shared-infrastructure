variable "name" {
	type = string
}
variable "env" {
  type = string
}
variable "resource_group_name" {
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

variable "application_names" {
	type = list(string)
	description = "List of application names"
	default = []
}