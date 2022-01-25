resource "random_password" "pact_db_password" {
  length      = 20
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
}

resource "azurerm_storage_blob" "pact_db_password" {
  name                   = "pact_db_content"
  storage_account_name   = "hmiapiminfra${var.environment}sa"
  storage_container_name = "hmiapimterraform"
  type                   = "Block"
  source_content         = random_password.pact_db_password.result
}