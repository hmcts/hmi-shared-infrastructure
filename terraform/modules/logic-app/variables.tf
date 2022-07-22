variable "env" {
  type = string
  description = "The short name of the current enviornment"
}
variable "resource_group" {
  type = string
  description = "Name of the resource group for the logic app"
}
variable "location" {
  type = string
  description = "Geographical location of resource e.g uksouth"
}
variable "common_tags" {
  type        = map(string)
  description = "Tags for the Azure resources"
}
variable "dtu_sa" {
	type = string
	description = "Name for the Storage account"
}