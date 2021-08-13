resource "azurerm_key_vault_certificate" "cert" {
  for_each     = var.certificates
  name         = lookup(each.value, "name")
  key_vault_id = var.keyvault_id

  dynamic "certificate" {
    for_each = lookup(each.value, "content") != "" ? [1] : []
    content {
      contents = lookup(each.value, "content")
    }
  }

  certificate_policy {
    issuer_parameters {
      name = lookup(each.value, "issuer_name")
    }

    key_properties {
      exportable = lookup(each.value, "key_properties_exportable")
      key_size   = lookup(each.value, "key_properties_key_size")
      key_type   = lookup(each.value, "key_properties_key_type")
      reuse_key  = lookup(each.value, "key_properties_reuse_key")
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
      extended_key_usage = lookup(each.value, "extended_key_usage")

      key_usage = lookup(each.value, "key_usage")

      subject_alternative_names {
        dns_names = lookup(each.value, "dns_names")
      }

      subject            = lookup(each.value, "subject")
      validity_in_months = lookup(each.value, "validity_in_months")
    }
  }
}