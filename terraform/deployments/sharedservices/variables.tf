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

variable "active_directory_group" {
  type        = string
  description = "Active Directory Group Name"
  default     = "DTS HMI"
}

variable "pfx_path" {
  type        = string
  description = "Path to PFX to be uploaded"
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

