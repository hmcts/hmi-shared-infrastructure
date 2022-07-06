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