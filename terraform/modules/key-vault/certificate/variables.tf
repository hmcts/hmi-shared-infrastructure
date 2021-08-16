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
}
variable "cert_validity_in_months" {
  type        = number
  description = "Certificate Validity in months"
  default     = 12
}
variable "cert_subject" {
  type        = string
  description = "Certificate Subject"
}