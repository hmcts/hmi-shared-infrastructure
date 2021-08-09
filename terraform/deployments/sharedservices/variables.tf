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