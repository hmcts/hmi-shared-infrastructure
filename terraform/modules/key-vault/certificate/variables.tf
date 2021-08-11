variable "cert_name" {
  type        = string
  description = "Certificate Name"
}
variable "keyvault_id" {
  type        = string
  description = "Parent Key Vault ID"
}
variable "cert_dns_names" {
  type        = list(string)
  description = "DNS Names for Certificate"
  default     = []
}
variable "cert_validity_in_months" {
  type        = number
  description = "Certificate Validity in months"
  default     = 12
}
variable "cert_subject" {
  type        = string
  description = "Certificate Subject"
  default     = ""
}
variable "cert_content" {
  type        = string
  description = "Certificate Content"
  default     = ""
}
variable "cert_issuer_name" {
  type        = string
  description = "Certificate Issuer Name"
  default     = "Self"
}
variable "cert_key_properties" {
  type = object({
    exportable = bool
    key_size   = number
    key_type   = string
    reuse_key  = bool
  })
  description = "value"
  default = {
    exportable = true
    key_size   = 2048
    key_type   = "RSA"
    reuse_key  = true
  }
}
variable "cert_extended_key_usage" {
  type        = list(string)
  description = "Certificate Extended Key Usage"
  default     = ["1.3.6.1.5.5.7.3.1"]
}
variable "cert_key_usage" {
  type        = list(string)
  description = "Certificate Key Usage"
  default = [
    "cRLSign",
    "dataEncipherment",
    "digitalSignature",
    "keyAgreement",
    "keyCertSign",
    "keyEncipherment",
  ]
}