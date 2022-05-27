locals {
	app_list = ["cft", "crime", "dtu", "snl"]
	key_vault_name = "hmi-shared-kv-${var.environment}"
}

data "azuread_application" "cft_client" {
	display_name = "cft-client"
}

data "azuread_application" "crime_client" {
	display_name = "crime-client"
}

data "azuread_application" "dtu_client" {
	display_name = "dtu-client"
}

data "azuread_application" "snl_client" {
	display_name = "snl-client"
}

resource "azurerm_automation_account" "hmi_automation" {
	name = "hmi-automation-${var.environment}"
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
	source = "git@hmcts/cnp-module-automation-runbook-sas-token-renewal?ref=master"

	name = each.value.name
	resource_group_name = azurerm_resource_group.rg.name
}

module "automation_runbook_sas_token_renewal" {
  for_each = local.app_list
  source   = "git@hmcts/cnp-module-automation-runbook-sas-token-renewal?ref=master"

  name                = each.value.name
  resource_group_name = azurerm_resource_group.rg.name

  environment = var.env
  product     = var.product

  key_vault_name = local.key_vault_name

  automation_account_name = azurerm_automation_account.hmi_automation.name

  tags = var.common_tags

}