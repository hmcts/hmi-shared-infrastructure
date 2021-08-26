module "keyvault_certificate" {
  source = "../../modules/key-vault/certificate"

  keyvault_id = module.kv.key_vault_id

  certificates = {
    "${local.certificate_name}" = {
      name               = local.certificate_name
      content            = filebase64(var.pfx_path)
      validity_in_months = 13
      key_usage = [
        "digitalSignature",
        "keyEncipherment"
      ]
      extended_key_usage = [
        "1.3.6.1.5.5.7.3.1",
        "1.3.6.1.5.5.7.3.2"
      ]

      key_properties_exportable = true
      key_properties_key_size   = 4096
      key_properties_key_type   = "RSA"
      key_properties_reuse_key  = false

      issuer_name = "Self"
      dns_names = []
      subject = ""
    }
  }
}
