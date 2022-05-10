variable "managed_identity_name" {
  type        = string
  description = "Managed Identity Name"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}