variable "keyvault_id" {
  type        = string
  description = "Parent Key Vault ID"
}
variable "certificates" {
  type = map(object({
    name                      = string
    validity_in_months        = number
    content                   = string
    issuer_name               = string
    key_properties_exportable = bool
    key_properties_key_size   = number
    key_properties_key_type   = string
    key_properties_reuse_key  = bool
    extended_key_usage        = list(string)
    key_usage                 = list(string)
    dns_names                 = list(string)
    subject                   = string
  }))
  description = "List of Certificates"
  default     = {}
}