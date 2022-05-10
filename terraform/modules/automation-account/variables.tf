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