locals {
	app_list = toset( var.application_names )
	key_vault_name = "hmi-shared-kv-${var.environment}"
}

resource "azurerm_automation_account" "hmi_automation" {
	name = var.name
	location = var.location
	resource_group_name = var.resource_group
	sku_name = var.automation_account_sku_name

	identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
      data.azurerm_user_assigned_identity.app_mi.id,
      data.azurerm_user_assigned_identity.apim_mi.id
    ]
  }
  
	tags = var.common_tags
}

module "automation_runbook_sas_token_renewal" {
  for_each = local.app_list
  source   = "git@hmcts/cnp-module-automation-runbook-sas-token-renewal?ref=master"

  name                = each.value.name
  resource_group_name = azurerm_resource_group.rg.name

  environment = var.env
  product     = var.product

  storage_account_name = "hmidtu${var.env}"
  container_name = "rota"
  blob_name = ""

  key_vault_name = local.key_vault_name
  secret_name = "hmi-${local.applist.key}-sas-${var.env}"

  automation_account_name = azurerm_automation_account.hmi_automation.name

  tags = var.common_tags

}