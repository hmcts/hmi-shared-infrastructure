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
variable "api_subscription" {
	type = string
	description = "Subscription of the API connections"
}