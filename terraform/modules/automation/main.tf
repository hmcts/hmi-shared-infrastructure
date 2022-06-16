locals {
	key_vault_name = "hmi-shared-kv-${var.env}"
	sa_list = toset(["hmidtu${var.env}", "hmiapiminfra${var.env}sa", "hmiapimwatcher${var.env}", "hmisharedinfrasa${var.env}"])
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
  for_each = local.sa_list
  name                = each.value
  resource_group_name = var.resource_group
}

resource "azurerm_role_assignment" "aa_to_sa" {
  for_each = {for i in local.sa_list : i =>  data.azurerm_storage_account.sa[i].id}
  scope                = each.value
  role_definition_name = "Contributor"
  principal_id         = azurerm_automation_account.hmi_automation.identity.0.principal_id
}

module "automation_runbook_sas_token_renewal" {
  for_each = var.sas_tokens
  source   = "git::https://github.com/hmcts/cnp-module-automation-runbook-sas-token-renewal?ref=master"

  name                = "rotate-sas-tokens-${each.value.storage_account}-${each.value.container}-${each.value.blob}-${each.value.permissions}"
  resource_group_name = var.resource_group

  environment = var.env

  storage_account_name = each.value.storage_account
  container_name = each.value.container
  blob_name = each.value.blob

  key_vault_name = local.key_vault_name
  secret_name = "hmi-sas-${each.value.container}-${each.value.blob}-${each.value.permissions}"

  expiry_date = each.value.expiry_date

  automation_account_name = azurerm_automation_account.hmi_automation.name

  tags = var.common_tags

}