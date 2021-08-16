output "cert_secret_id" {
  value = azurerm_key_vault_certificate.cert.secret_id
}

output "cert_thumbprint" {
  value = azurerm_key_vault_certificate.cert.thumbprint
}