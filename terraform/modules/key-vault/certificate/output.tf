output "cert_secret_id" {
  value = toset([
    for cert in azurerm_key_vault_certificate.cert : cert.secret_id
  ])
}

output "cert_thumbprint" {
  value = toset([
    for cert in azurerm_key_vault_certificate.cert : cert.thumbprint
  ])
}