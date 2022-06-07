locals {
	app_list = toset(["cft", "crime", "dtu", "snl"])
	key_vault_name = "hmi-shared-kv-${var.env}"
}

resource "azurerm_automation_account" "hmi_automation" {
	name = var.name
	location = var.location
	resource_group_name = var.resource_group
	sku_name = var.automation_account_sku_name

	identity {
    type = "SystemAssigned"
  }
  
	tags = var.common_tags
}

data "azurerm_storage_account" "sa" {
  name                = "hmidtu${var.env}"
  resource_group_name = var.resource_group
}

resource "azurerm_role_assignment" "aa_to_sa" {
  scope                = data.azurerm_storage_account.sa.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_automation_account.hmi_automation.identity.0.principal_id
}

module "automation_runbook_sas_token_renewal" {
  for_each = local.app_list
  source   = "git::https://github.com/hmcts/cnp-module-automation-runbook-sas-token-renewal?ref=master"

  name                = "rotate-sas-tokens-${each.value}"
  resource_group_name = var.resource_group

  environment = var.env

  storage_account_name = "hmidtu${var.env}"
  container_name = "rota"
  blob_name = ""

  key_vault_name = local.key_vault_name
  secret_name = "hmi-${each.key}-sas-${var.env}"

  expiry_date = timeadd(timestamp(), "2160h")

  automation_account_name = azurerm_automation_account.hmi_automation.name

  tags = var.common_tags

}