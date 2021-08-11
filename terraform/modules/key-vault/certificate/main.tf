resource "azurerm_key_vault_certificate" "cert" {
  name         = var.cert_name
  key_vault_id = var.keyvault_id

  dynamic "certificate" {
    for_each = var.cert_content != "" ? [1] : []
    content {
      contents = var.cert_content
    }
  }

  certificate_policy {
    issuer_parameters {
      name = var.cert_issuer_name
    }

    key_properties {
      exportable = var.cert_key_properties.exportable
      key_size   = var.cert_key_properties.key_size
      key_type   = var.cert_key_properties.key_type
      reuse_key  = var.cert_key_properties.reuse_key
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = var.cert_extended_key_usage

      key_usage = var.cert_key_usage

      subject_alternative_names {
        dns_names = var.cert_dns_names
      }

      subject            = var.cert_subject
      validity_in_months = var.cert_validity_in_months
    }
  }
}